Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab3KRJDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:03:41 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58701 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab3KRJD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:03:28 -0500
Date: Mon, 18 Nov 2013 10:03:10 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Dave Airlie <airlied@gmail.com>,
        devel@driverdev.osuosl.org, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: imx-drm: Fix modular build of DRM_IMX_IPUV3
Message-ID: <20131118090309.GU24559@pengutronix.de>
References: <20131112171544.GR20328@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112171544.GR20328@hansolo.jdub.homelinux.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:02:53 up 85 days, 18:33, 52 users,  load average: 0.12, 0.11,
 0.19
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 12:15:45PM -0500, Josh Boyer wrote:
> commit b8d181e408af (staging: drm/imx: add drm plane support) added a file
> to the make target for DRM_IMX_IPUV3 but didn't adjust the objs required
> to actually build that as a module.  Kbuild got confused and this lead to
> link errors like:
> 
> ERROR: "ipu_plane_disable" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> ERROR: "ipu_plane_enable" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> 
> Additionally, it added a call to imx_drm_crtc_id which also fails with a
> link error as above.  To fix this, we adjust the make target with the proper
> objs, which will change the name of the resulting .ko.  We also add an
> EXPORT_SYMBOL_GPL for imx_drm_crtc_id.
> 
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>


Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
>  drivers/staging/imx-drm/Makefile       | 4 +++-
>  drivers/staging/imx-drm/imx-drm-core.c | 1 +
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/imx-drm/Makefile b/drivers/staging/imx-drm/Makefile
> index 2c3a9e1..8742432 100644
> --- a/drivers/staging/imx-drm/Makefile
> +++ b/drivers/staging/imx-drm/Makefile
> @@ -8,4 +8,6 @@ obj-$(CONFIG_DRM_IMX_TVE) += imx-tve.o
>  obj-$(CONFIG_DRM_IMX_LDB) += imx-ldb.o
>  obj-$(CONFIG_DRM_IMX_FB_HELPER) += imx-fbdev.o
>  obj-$(CONFIG_DRM_IMX_IPUV3_CORE) += ipu-v3/
> -obj-$(CONFIG_DRM_IMX_IPUV3)	+= ipuv3-crtc.o ipuv3-plane.o
> +
> +imx-ipuv3-crtc-objs  := ipuv3-crtc.o ipuv3-plane.o
> +obj-$(CONFIG_DRM_IMX_IPUV3)	+= imx-ipuv3-crtc.o
> diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
> index 4483d47..2b366d8 100644
> --- a/drivers/staging/imx-drm/imx-drm-core.c
> +++ b/drivers/staging/imx-drm/imx-drm-core.c
> @@ -72,6 +72,7 @@ int imx_drm_crtc_id(struct imx_drm_crtc *crtc)
>  {
>  	return crtc->pipe;
>  }
> +EXPORT_SYMBOL_GPL(imx_drm_crtc_id);
>  
>  static void imx_drm_driver_lastclose(struct drm_device *drm)
>  {
> -- 
> 1.8.3.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

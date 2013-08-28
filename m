Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab3H1F2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 01:28:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44015 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab3H1F2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 01:28:03 -0400
Date: Wed, 28 Aug 2013 07:27:58 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: gregkh@linuxfoundation.org, p.zabel@pengutronix.de, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] imx-drm: Fix probe failure
Message-ID: <20130828052758.GQ30088@pengutronix.de>
References: <1377657163-6606-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377657163-6606-1-git-send-email-festevam@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:26:53 up 3 days, 14:57, 23 users,  load average: 0.00, 0.01, 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 11:32:43PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Since commit b5dc0d10 (drm/imx: kill firstopen callback) the following probe
> failure is seen:
> 
> [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [drm] No driver support for vblank timestamp query.
> [drm] Initialized imx-drm 1.0.0 20120507 on minor 0
> imx-ldb ldb.10: adding encoder failed with -16
> imx-ldb: probe of ldb.10 failed with error -16
> imx-ipuv3 2400000.ipu: IPUv3H probed
> imx-ipuv3 2800000.ipu: IPUv3H probed
> imx-ipuv3-crtc imx-ipuv3-crtc.0: adding crtc failed with -16.
> imx-ipuv3-crtc: probe of imx-ipuv3-crtc.0 failed with error -16
> imx-ipuv3-crtc imx-ipuv3-crtc.1: adding crtc failed with -16.
> imx-ipuv3-crtc: probe of imx-ipuv3-crtc.1 failed with error -16
> imx-ipuv3-crtc imx-ipuv3-crtc.2: adding crtc failed with -16.
> imx-ipuv3-crtc: probe of imx-ipuv3-crtc.2 failed with error -16
> imx-ipuv3-crtc imx-ipuv3-crtc.3: adding crtc failed with -16.
> imx-ipuv3-crtc: probe of imx-ipuv3-crtc.3 failed with error -16
> 
> 'imxdrm->references' is not keeping the references correctly, causing the probe
> to fail, so let's get rid of it.
> 
> After this patch, lvds panel is functional on a mx6qsabrelite board.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/staging/imx-drm/imx-drm-core.c | 25 +------------------------
>  1 file changed, 1 insertion(+), 24 deletions(-)
> 
> diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
> index 47c5888..98eac33 100644
> --- a/drivers/staging/imx-drm/imx-drm-core.c
> +++ b/drivers/staging/imx-drm/imx-drm-core.c
> @@ -41,7 +41,6 @@ struct imx_drm_device {
>  	struct list_head			encoder_list;
>  	struct list_head			connector_list;
>  	struct mutex				mutex;
> -	int					references;

Nack. We need the references to prevent that encoders/connectors are
(de)registered while the device is active. Simply dropping this code is
no solution.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

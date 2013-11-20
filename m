Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3KTB5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 20:57:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211Ab3KTB5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 20:57:11 -0500
Date: Tue, 19 Nov 2013 20:56:59 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Dave Airlie <airlied@gmail.com>,
        devel@driverdev.osuosl.org, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: imx-drm: Fix modular build of DRM_IMX_IPUV3
Message-ID: <20131120015659.GF1908@hansolo.jdub.homelinux.org>
References: <20131112171544.GR20328@hansolo.jdub.homelinux.org>
 <20131118090309.GU24559@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118090309.GU24559@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 10:03:10AM +0100, Sascha Hauer wrote:
> On Tue, Nov 12, 2013 at 12:15:45PM -0500, Josh Boyer wrote:
> > commit b8d181e408af (staging: drm/imx: add drm plane support) added a file
> > to the make target for DRM_IMX_IPUV3 but didn't adjust the objs required
> > to actually build that as a module.  Kbuild got confused and this lead to
> > link errors like:
> > 
> > ERROR: "ipu_plane_disable" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> > ERROR: "ipu_plane_enable" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> > 
> > Additionally, it added a call to imx_drm_crtc_id which also fails with a
> > link error as above.  To fix this, we adjust the make target with the proper
> > objs, which will change the name of the resulting .ko.  We also add an
> > EXPORT_SYMBOL_GPL for imx_drm_crtc_id.
> > 
> > Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> 
> 
> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
> 
> Sascha

Thanks.  So who picks this fix up?  Greg, is that you?

josh

> 
> > ---
> >  drivers/staging/imx-drm/Makefile       | 4 +++-
> >  drivers/staging/imx-drm/imx-drm-core.c | 1 +
> >  2 files changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/imx-drm/Makefile b/drivers/staging/imx-drm/Makefile
> > index 2c3a9e1..8742432 100644
> > --- a/drivers/staging/imx-drm/Makefile
> > +++ b/drivers/staging/imx-drm/Makefile
> > @@ -8,4 +8,6 @@ obj-$(CONFIG_DRM_IMX_TVE) += imx-tve.o
> >  obj-$(CONFIG_DRM_IMX_LDB) += imx-ldb.o
> >  obj-$(CONFIG_DRM_IMX_FB_HELPER) += imx-fbdev.o
> >  obj-$(CONFIG_DRM_IMX_IPUV3_CORE) += ipu-v3/
> > -obj-$(CONFIG_DRM_IMX_IPUV3)	+= ipuv3-crtc.o ipuv3-plane.o
> > +
> > +imx-ipuv3-crtc-objs  := ipuv3-crtc.o ipuv3-plane.o
> > +obj-$(CONFIG_DRM_IMX_IPUV3)	+= imx-ipuv3-crtc.o
> > diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
> > index 4483d47..2b366d8 100644
> > --- a/drivers/staging/imx-drm/imx-drm-core.c
> > +++ b/drivers/staging/imx-drm/imx-drm-core.c
> > @@ -72,6 +72,7 @@ int imx_drm_crtc_id(struct imx_drm_crtc *crtc)
> >  {
> >  	return crtc->pipe;
> >  }
> > +EXPORT_SYMBOL_GPL(imx_drm_crtc_id);
> >  
> >  static void imx_drm_driver_lastclose(struct drm_device *drm)
> >  {
> > -- 
> > 1.8.3.1
> > 
> > 
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

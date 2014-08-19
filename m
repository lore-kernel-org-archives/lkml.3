Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaHSPnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:43:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58459 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaHSPnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:43:00 -0400
Message-ID: <1408462964.2899.51.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 1/1] staging: imx-drm: Lines over 80 characters fixed.
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Yannis Damigos <giannis.damigos@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 19 Aug 2014 17:42:44 +0200
In-Reply-To: <1408462006-15873-1-git-send-email-giannis.damigos@gmail.com>
References: <20140819150359.GF30401@n2100.arm.linux.org.uk>
	 <1408462006-15873-1-git-send-email-giannis.damigos@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 19.08.2014, 18:26 +0300 schrieb Yannis Damigos:
> This is a patch to the ipuv3-crtc.c file that fixes up two "lines
> over 80 characters" warnings found by the checkpatch.pl tool,
> keeping the alignment of the x/y/width/height parameters for
> readability.
> 
> Signed-off-by: Yannis Damigos <giannis.damigos@gmail.com>
> ---
>  drivers/staging/imx-drm/ipuv3-crtc.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/imx-drm/ipuv3-crtc.c b/drivers/staging/imx-drm/ipuv3-crtc.c
> index 720868b..11e84a2 100644
> --- a/drivers/staging/imx-drm/ipuv3-crtc.c
> +++ b/drivers/staging/imx-drm/ipuv3-crtc.c
> @@ -201,7 +201,8 @@ static int ipu_crtc_mode_set(struct drm_crtc *crtc,
>  		return ret;
>  	}
>  
> -	return ipu_plane_mode_set(ipu_crtc->plane[0], crtc, mode, crtc->primary->fb,
> +	return ipu_plane_mode_set(ipu_crtc->plane[0], crtc, mode,
> +				  crtc->primary->fb,
>  				  0, 0, mode->hdisplay, mode->vdisplay,
>  				  x, y, mode->hdisplay, mode->vdisplay);
>  }
> @@ -226,9 +227,11 @@ static irqreturn_t ipu_irq_handler(int irq, void *dev_id)
>  	imx_drm_handle_vblank(ipu_crtc->imx_crtc);
>  
>  	if (ipu_crtc->newfb) {
> +		struct ipu_plane *plane = ipu_crtc->plane[0];
> +
>  		ipu_crtc->newfb = NULL;
> -		ipu_plane_set_base(ipu_crtc->plane[0], ipu_crtc->base.primary->fb,
> -				ipu_crtc->plane[0]->x, ipu_crtc->plane[0]->y);
> +		ipu_plane_set_base(plane, ipu_crtc->base.primary->fb,
> +				   plane->x, plane->y);
>  		ipu_crtc_handle_pageflip(ipu_crtc);
>  	}

Yes, that does look better.

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp


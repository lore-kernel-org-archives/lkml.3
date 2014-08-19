Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaHSPEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:04:15 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55001 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752094AbaHSPEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:04:14 -0400
Date: Tue, 19 Aug 2014 16:03:59 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Yannis Damigos <giannis.damigos@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: imx-drm: Lines over 80 characters fixed.
Message-ID: <20140819150359.GF30401@n2100.arm.linux.org.uk>
References: <1408457139.2899.11.camel@paszta.hi.pengutronix.de> <1408458970-27097-1-git-send-email-giannis.damigos@gmail.com> <1408458970-27097-2-git-send-email-giannis.damigos@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408458970-27097-2-git-send-email-giannis.damigos@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 05:36:10PM +0300, Yannis Damigos wrote:
> diff --git a/drivers/staging/imx-drm/ipuv3-crtc.c b/drivers/staging/imx-drm/ipuv3-crtc.c
> index 720868b..d6657a0 100644
> --- a/drivers/staging/imx-drm/ipuv3-crtc.c
> +++ b/drivers/staging/imx-drm/ipuv3-crtc.c
> @@ -201,9 +201,10 @@ static int ipu_crtc_mode_set(struct drm_crtc *crtc,
>  		return ret;
>  	}
>  
> -	return ipu_plane_mode_set(ipu_crtc->plane[0], crtc, mode, crtc->primary->fb,
> -				  0, 0, mode->hdisplay, mode->vdisplay,
> -				  x, y, mode->hdisplay, mode->vdisplay);
> +	return ipu_plane_mode_set(ipu_crtc->plane[0], crtc, mode,
> +			crtc->primary->fb,
> +			0, 0, mode->hdisplay, mode->vdisplay,
> +			x, y, mode->hdisplay, mode->vdisplay);

Why change the indentation like this?  There is a wisdom which suggests
that it's better to align the arguments with the function call's first
argument, unless there is a strong reason not to.  In this case, I can't
see a strong reason to change the indentation to some different style
here.

>  }
>  
>  static void ipu_crtc_handle_pageflip(struct ipu_crtc *ipu_crtc)
> @@ -227,7 +228,8 @@ static irqreturn_t ipu_irq_handler(int irq, void *dev_id)
>  
>  	if (ipu_crtc->newfb) {
>  		ipu_crtc->newfb = NULL;
> -		ipu_plane_set_base(ipu_crtc->plane[0], ipu_crtc->base.primary->fb,
> +		ipu_plane_set_base(ipu_crtc->plane[0],
> +				ipu_crtc->base.primary->fb,
>  				ipu_crtc->plane[0]->x, ipu_crtc->plane[0]->y);

What may make better sense here is:
		struct ipu_plane *plane = ipu_crtc->plane[0];

		ipu_crtc->newfb = NULL;
		ipu_plane_set_base(plane, ipu_crtc->base.primary->fb,
				   plane->x, plane->y);

which to me looks loads nicer.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.

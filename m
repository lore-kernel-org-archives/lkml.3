Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967243Ab3DROue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 10:50:34 -0400
Received: from [216.32.180.13] ([216.32.180.13]:11171 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S966390Ab3DROuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 10:50:32 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 18 Apr 2013 22:48:39 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Marek Vasut <marex@denx.de>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Brian Lilly <brian@crystalfontz.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] video: mxsfb: Fix colors display on lower color depth
Message-ID: <20130418144838.GD2222@S2101-09.ap.freescale.net>
References: <516EBCA4.1020609@free-electrons.com>
 <1366277032-671-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1366277032-671-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy Sascha.

Shawn

On Thu, Apr 18, 2013 at 11:23:52AM +0200, Maxime Ripard wrote:
> The current code always registers as a 32 bits display, and uses the
> hardware to drop the MSB of each color to abjust to the interface width
> used by the panel.
> 
> This results on 18 bits (and probably 16 bits display as well) in colors
> being displayed poorly, because the MSB are obviously the most important
> bits for each color definition.
> 
> The default controller behaviour when using an interface width smaller
> than the color depth is to drop the LSBs of each color, which makes more
> sense because you lose the least important part of the color definition.
> 
> So, to fix the colors display, just get back to the default controller
> behaviour.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/video/mxsfb.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
> index 755556c..2cfaf8b 100644
> --- a/drivers/video/mxsfb.c
> +++ b/drivers/video/mxsfb.c
> @@ -424,11 +424,6 @@ static int mxsfb_set_par(struct fb_info *fb_info)
>  			return -EINVAL;
>  		case STMLCDIF_16BIT:
>  		case STMLCDIF_18BIT:
> -			/* 24 bit to 18 bit mapping */
> -			ctrl |= CTRL_DF24; /* ignore the upper 2 bits in
> -					    *  each colour component
> -					    */
> -			break;
>  		case STMLCDIF_24BIT:
>  			/* real 24 bit */
>  			break;
> -- 
> 1.7.10.4
> 


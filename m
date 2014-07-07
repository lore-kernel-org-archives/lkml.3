Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaGGIPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:15:00 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:46102 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750855AbaGGIO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:14:56 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19spA49fr6CHA+VicWspjXj
Date: Mon, 7 Jul 2014 01:14:56 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: balbi@ti.com, linux@arm.linux.org.uk, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mach-omap1: Fix call to omap_cfg_reg
Message-ID: <20140707081456.GH28884@atomide.com>
References: <1404493320-5606-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404493320-5606-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicholas Krause <xerofoify@gmail.com> [140704 10:03]:
> This patch fixes the call to ompa_cfg_reg(USB2_SPEED) in the case
> that the cpu is a omap16xx and the nwires are not equal to 3.

This is most likely unsafe to do as the pin is probably
shared with some other device and we have to rely for
the bootloader to do the right thing for the board.

Regards,

Tony
 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  arch/arm/mach-omap1/usb.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-omap1/usb.c b/arch/arm/mach-omap1/usb.c
> index 4118db5..17e3139 100644
> --- a/arch/arm/mach-omap1/usb.c
> +++ b/arch/arm/mach-omap1/usb.c
> @@ -504,8 +504,7 @@ static u32 __init omap1_usb2_init(unsigned nwires, unsigned alt_pingroup)
>  		omap_cfg_reg(W9_USB2_TXEN);
>  		omap_cfg_reg(W5_USB2_SE0);
>  		if (nwires != 3)
> -			omap_cfg_reg(Y5_USB2_RCV);
> -		// FIXME omap_cfg_reg(USB2_SPEED);
> +			omap_cfg_reg(USB2_SPEED)
>  	} else {
>  		pr_debug("usb%d cpu unrecognized\n", 1);
>  		return 0;
> -- 
> 1.9.1
> 

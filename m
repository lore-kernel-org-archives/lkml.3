Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab3KNSiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 13:38:00 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:19400 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab3KNShu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 13:37:50 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19obK1+YHSODIyCXTbjoZJx
Date: Thu, 14 Nov 2013 10:37:42 -0800
From: Tony Lindgren <tony@atomide.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] include/linux/usb/usb_phy_gen_xceiv.h: check built-in
 or module for swithing usb_nop_xceiv_register() implementation
Message-ID: <20131114183742.GN10317@atomide.com>
References: <52679D19.903@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52679D19.903@asianux.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chen Gang <gang.chen@asianux.com> [131023 02:57]:
> When CONFIG_NOP_USB_XCEIV is as 'm', usb_nop_xceiv_register() will be
> exported when the related module is loaded. So for built-in source
> code, still need use the empty one.
> 
> Or it will can not pass compiling, the related error (for arm, with 
> allmodconfig):
> 
>   arch/arm/mach-omap2/built-in.o: In function `omap3_evm_init':
>   arch/arm/mach-omap2/board-omap3evm.c:703: undefined reference to `usb_nop_xceiv_register'
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Added Felipe to cc, he should probably deal with this one.

Regards,

Tony

> ---
>  include/linux/usb/usb_phy_gen_xceiv.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/usb/usb_phy_gen_xceiv.h b/include/linux/usb/usb_phy_gen_xceiv.h
> index f9a7e7b..8515958 100644
> --- a/include/linux/usb/usb_phy_gen_xceiv.h
> +++ b/include/linux/usb/usb_phy_gen_xceiv.h
> @@ -12,7 +12,8 @@ struct usb_phy_gen_xceiv_platform_data {
>  	unsigned int needs_reset:1;
>  };
>  
> -#if IS_ENABLED(CONFIG_NOP_USB_XCEIV)
> +#if IS_BUILTIN(CONFIG_NOP_USB_XCEIV) || \
> +	(IS_MODULE(CONFIG_NOP_USB_XCEIV) && defined(MODULE))
>  /* sometimes transceivers are accessed only through e.g. ULPI */
>  extern void usb_nop_xceiv_register(void);
>  extern void usb_nop_xceiv_unregister(void);
> -- 
> 1.7.7.6

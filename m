Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab3KDJdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 04:33:38 -0500
Received: from intranet.asianux.com ([58.214.24.6]:51076 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab3KDJdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 04:33:36 -0500
X-Spam-Score: -100.8
Message-ID: <527769AF.9000702@asianux.com>
Date: Mon, 04 Nov 2013 17:32:31 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Greg KH <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] include/linux/usb/usb_phy_gen_xceiv.h: check built-in
 or module for swithing usb_nop_xceiv_register() implementation
References: <52679D19.903@asianux.com>
In-Reply-To: <52679D19.903@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

Please help check this patch, when you have time.

Thanks.

On 10/23/2013 05:55 PM, Chen Gang wrote:
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
> 


-- 
Chen Gang

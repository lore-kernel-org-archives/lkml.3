Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab3IQXkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 19:40:32 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52368 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753421Ab3IQXkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 19:40:31 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX198bsltuCxquRhKg0rZbmEk
Date: Tue, 17 Sep 2013 16:40:22 -0700
From: Tony Lindgren <tony@atomide.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: ARM: OMAP2: Make MACH_OMAP3EVM select NOP_USB_XCEIV
Message-ID: <20130917234021.GO9994@atomide.com>
References: <20130904133850.GC12834@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904133850.GC12834@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Josh Boyer <jwboyer@redhat.com> [130904 06:46]:
> The board-omap3evm.c file unconditionally calls usb_nop_xceiv_register but
> doesn't ensure this is built-in.  This can lead to build failures like:
> 
> arch/arm/mach-omap2/built-in.o: In function `omap3_evm_init':
> linux-3.12.0-0.rc0.git2.1.fc21.armv7hl/arch/arm/mach-omap2/board-omap3evm.c:686: undefined reference to `usb_nop_xceiv_register'
> make: *** [vmlinux] Error 1
> 
> Make MACH_OMAP3EVM select NOP_USB_XCEIV to avoid this.
> 
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> ---
>  arch/arm/mach-omap2/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index 3eed000..3350389 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -258,6 +258,7 @@ config MACH_OMAP3EVM
>  	depends on ARCH_OMAP3
>  	default y
>  	select OMAP_PACKAGE_CBB
> +	select NOP_USB_XCEIV
>  
>  config MACH_OMAP3517EVM
>  	bool "OMAP3517/ AM3517 EVM board"

I think we should rather have the code in board-omap3evm.c
to be ifdef CONFIG_NOP_USB_XCEIV as it's a selectable option.

Regards,

Tony

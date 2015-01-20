Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbbATJXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:23:18 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:65298 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752017AbbATJXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:23:15 -0500
Message-ID: <1421745792.9655.98.camel@x220>
Subject: Re: [PATCH 5/7] ARM: at91: move debug-macro.S into the common space
From: Paul Bolle <pebolle@tiscali.nl>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 20 Jan 2015 10:23:12 +0100
In-Reply-To: <1421088136-10172-6-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421088136-10172-1-git-send-email-alexandre.belloni@free-electrons.com>
	 <1421088136-10172-6-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jan 2015 09:23:13.0364 (UTC) FILETIME=[B6FCE140:01D03492]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre,

On Mon, 2015-01-12 at 19:42 +0100, Alexandre Belloni wrote:
> Move debug-macro.S from include/mach/ to include/debug where all other common
> debug macros are.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

This patch became commit 5f58c97099f2 ("ARM: at91: move debug-macro.S
into the common space") in today's linux-next (ie, next-20150120). I
noticed because a script I use to check linux-next spotted a problem in
it.

>  MAINTAINERS                                           |  1 +
>  arch/arm/Kconfig.debug                                |  9 +++++++--
>  .../mach/debug-macro.S => include/debug/at91.S}       | 19 +++++++++++--------
>  3 files changed, 19 insertions(+), 10 deletions(-)
>  rename arch/arm/{mach-at91/include/mach/debug-macro.S => include/debug/at91.S} (68%)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3589d67437f8..8c25979a3c43 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -877,6 +877,7 @@ F:	arch/arm/boot/dts/at91*.dts
>  F:	arch/arm/boot/dts/at91*.dtsi
>  F:	arch/arm/boot/dts/sama*.dts
>  F:	arch/arm/boot/dts/sama*.dtsi
> +F:	arch/arm/include/debug/at91.S
>  
>  ARM/ATMEL AT91 Clock Support
>  M:	Boris Brezillon <boris.brezillon@free-electrons.com>
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 5ddd4906f7a7..e34d24949c6a 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -115,15 +115,18 @@ choice
>  		    0x80024000      | 0xf0024000     | UART9
>  
>  	config AT91_DEBUG_LL_DBGU0
> -		bool "Kernel low-level debugging on rm9200, 9260/9g20, 9261/9g10 and 9rl"
> +		bool "Kernel low-level debugging on rm9200, 9260/9g20, 9261/9g10, 9rl, 9x5, 9n12"
> +		select DEBUG_AT91_UART

There's no Kconfig symbol DEBUG_AT91_UART in linux-next. So this select
is currently a nop. Why was it added?

>  		depends on HAVE_AT91_DBGU0
>  
>  	config AT91_DEBUG_LL_DBGU1
> -		bool "Kernel low-level debugging on 9263 and 9g45"
> +		bool "Kernel low-level debugging on 9263, 9g45 and sama5d3"
> +		select DEBUG_AT91_UART

Ditto.

>  		depends on HAVE_AT91_DBGU1
>  
>  	config AT91_DEBUG_LL_DBGU2
>  		bool "Kernel low-level debugging on sama5d4"
> +		select DEBUG_AT91_UART

Ditto.

>  		depends on HAVE_AT91_DBGU2
>  
>  	config DEBUG_BCM2835
> @@ -1165,6 +1168,8 @@ config DEBUG_LL_INCLUDE
>  	string
>  	default "debug/sa1100.S" if DEBUG_SA1100
>  	default "debug/8250.S" if DEBUG_LL_UART_8250 || DEBUG_UART_8250
> +	default "debug/at91.S" if AT91_DEBUG_LL_DBGU0 || AT91_DEBUG_LL_DBGU1 || \
> +				AT91_DEBUG_LL_DBGU2
>  	default "debug/asm9260.S" if DEBUG_ASM9260_UART
>  	default "debug/clps711x.S" if DEBUG_CLPS711X_UART1 || DEBUG_CLPS711X_UART2
>  	default "debug/meson.S" if DEBUG_MESON_UARTAO

Thanks,


Paul Bolle


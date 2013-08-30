Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab3H3Iwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 04:52:45 -0400
Received: from intranet.asianux.com ([58.214.24.6]:24976 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab3H3Iwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 04:52:43 -0400
X-Spam-Score: -100.9
Message-ID: <52205D17.5030706@asianux.com>
Date: Fri, 30 Aug 2013 16:51:35 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Yoshinori Sato <ysato@users.sourceforge.jp>, ak@linux.intel.com,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] h8300: Register: add prefix "H8_" to IER
References: <521F22F1.3090604@asianux.com>
In-Reply-To: <521F22F1.3090604@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For register ISR, also need add prefix, or it will cause issue too.

I will send patch v2 for it (may others also need prefix) after finish
allmodconfig.


Thanks.

On 08/29/2013 06:31 PM, Chen Gang wrote:
> IER is so common used (e.g. "include/media/saa7146.h", "drivers/isdn
> /hisax/hisax.h"), need add prefix for it, or it may be overridden (can
> not pass compiling with allmodconfig for h8300).
> 
> The related error:
> 
>     CC [M]  drivers/isdn/hisax/config.o
>   In file included from arch/h8300/include/asm/io.h:9:0,
>                    from drivers/isdn/hisax/hisax.h:12,
>                    from drivers/isdn/hisax/config.c:21:
>   arch/h8300/include/asm/regs306x.h:73:14: error: expected identifier or '(' before numeric constant
>    #define IER  0xFEE015
>                 ^
>   drivers/isdn/hisax/hisax.h:574:9: note: in expansion of macro 'IER'
>     u_char IER;
>            ^
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/h8300/include/asm/irq.h      |    4 ++--
>  arch/h8300/include/asm/regs267x.h |    2 +-
>  arch/h8300/include/asm/regs306x.h |    2 +-
>  arch/h8300/platform/h8300h/irq.c  |    4 ++--
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/h8300/include/asm/irq.h b/arch/h8300/include/asm/irq.h
> index 13d7c60..0964676 100644
> --- a/arch/h8300/include/asm/irq.h
> +++ b/arch/h8300/include/asm/irq.h
> @@ -14,7 +14,7 @@
>  #define EXT_IRQ6 18
>  #define EXT_IRQ7 19
>  #define EXT_IRQS 5
> -#define IER_REGS *(volatile unsigned char *)IER
> +#define IER_REGS *(volatile unsigned char *)H8_IER
>  #endif
>  #if defined(CONFIG_CPU_H8S)
>  #define NR_IRQS 128
> @@ -36,7 +36,7 @@
>  #define EXT_IRQ15 31
>  #define EXT_IRQS 15
>  
> -#define IER_REGS *(volatile unsigned short *)IER
> +#define IER_REGS *(volatile unsigned short *)H8_IER
>  #endif
>  
>  static __inline__ int irq_canonicalize(int irq)
> diff --git a/arch/h8300/include/asm/regs267x.h b/arch/h8300/include/asm/regs267x.h
> index 1bff731..0137ef0 100644
> --- a/arch/h8300/include/asm/regs267x.h
> +++ b/arch/h8300/include/asm/regs267x.h
> @@ -131,7 +131,7 @@
>  #define ISCRL 0xFFFE1C
>  
>  #define INTCR 0xFFFF31
> -#define IER   0xFFFF32
> +#define H8_IER   0xFFFF32
>  #define IERH  0xFFFF32
>  #define IERL  0xFFFF33
>  #define ISR   0xFFFF34
> diff --git a/arch/h8300/include/asm/regs306x.h b/arch/h8300/include/asm/regs306x.h
> index 027dd63..046bb61 100644
> --- a/arch/h8300/include/asm/regs306x.h
> +++ b/arch/h8300/include/asm/regs306x.h
> @@ -70,7 +70,7 @@
>  #define DTCR1B  0xFFFF3F
>  
>  #define ISCR 0xFEE014
> -#define IER  0xFEE015
> +#define H8_IER  0xFEE015
>  #define ISR  0xFEE016
>  #define IPRA 0xFEE018
>  #define IPRB 0xFEE019
> diff --git a/arch/h8300/platform/h8300h/irq.c b/arch/h8300/platform/h8300h/irq.c
> index 0a50353..ae1e01a 100644
> --- a/arch/h8300/platform/h8300h/irq.c
> +++ b/arch/h8300/platform/h8300h/irq.c
> @@ -70,12 +70,12 @@ void h8300_disable_irq_pin(unsigned int irq)
>  	case EXT_IRQ1:
>  	case EXT_IRQ2:
>  	case EXT_IRQ3:
> -		*(volatile unsigned char *)IER &= ~bitmask;
> +		*(volatile unsigned char *)H8_IER &= ~bitmask;
>  		H8300_GPIO_FREE(H8300_GPIO_P8, bitmask);
>  		break ;
>  	case EXT_IRQ4:
>  	case EXT_IRQ5:
> -		*(volatile unsigned char *)IER &= ~bitmask;
> +		*(volatile unsigned char *)H8_IER &= ~bitmask;
>  		H8300_GPIO_FREE(H8300_GPIO_P9, bitmask);
>  		break;
>  	}
> 


-- 
Chen Gang

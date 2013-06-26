Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3FZXIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 19:08:24 -0400
Received: from outbound-mail04.westnet.com.au ([203.10.1.245]:10897 "EHLO
	outbound-mail04.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752937Ab3FZXIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 19:08:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAL5zy1HYNY97/2dsb2JhbAANTsMHgRqDFwEBAQQ4QAEQCxgJFg8JAwIBAgFFBg0BBQIBAa9tki+PSweDYwOhY4pK
X-IronPort-AV: E=Sophos;i="4.87,947,1363104000"; 
   d="scan'208";a="108957717"
X-WN-REMOTEIP: 216.53.143.123
X-WN-ENVELOPESENDER: gerg@uclinux.org
X-WN-MID: 108957717
X-WN-SMTPAUTHID: gregungerer@westnet.com.au
Message-ID: <51CB745B.4060604@uclinux.org>
Date: Thu, 27 Jun 2013 09:08:11 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: uclinux-dev@uclinux.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68knommu: Mark config_BSP() __init
References: <1372189212-12136-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1372189212-12136-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 26/06/13 05:40, Geert Uytterhoeven wrote:
> Some instances of config_BSP() lack an __init annotation.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>

Looks good. Are you going to push it via your tree, or do you want
me too?

Regards
Greg

> ---
>   arch/m68k/platform/68000/m68328.c   |    3 ++-
>   arch/m68k/platform/68000/m68EZ328.c |    3 ++-
>   arch/m68k/platform/68000/m68VZ328.c |    3 ++-
>   arch/m68k/platform/68360/config.c   |    3 ++-
>   4 files changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/arch/m68k/platform/68000/m68328.c b/arch/m68k/platform/68000/m68328.c
> index a86eb66..e53caf4 100644
> --- a/arch/m68k/platform/68000/m68328.c
> +++ b/arch/m68k/platform/68000/m68328.c
> @@ -15,6 +15,7 @@
>
>   /***************************************************************************/
>
> +#include <linux/init.h>
>   #include <linux/types.h>
>   #include <linux/kernel.h>
>   #include <linux/rtc.h>
> @@ -42,7 +43,7 @@ void m68328_reset (void)
>
>   /***************************************************************************/
>
> -void config_BSP(char *command, int len)
> +void __init config_BSP(char *command, int len)
>   {
>     printk(KERN_INFO "\n68328 support D. Jeff Dionne <jeff@uclinux.org>\n");
>     printk(KERN_INFO "68328 support Kenneth Albanowski <kjahds@kjshds.com>\n");
> diff --git a/arch/m68k/platform/68000/m68EZ328.c b/arch/m68k/platform/68000/m68EZ328.c
> index a6eb72d..332b5e8 100644
> --- a/arch/m68k/platform/68000/m68EZ328.c
> +++ b/arch/m68k/platform/68000/m68EZ328.c
> @@ -13,6 +13,7 @@
>
>   /***************************************************************************/
>
> +#include <linux/init.h>
>   #include <linux/types.h>
>   #include <linux/kernel.h>
>   #include <linux/rtc.h>
> @@ -52,7 +53,7 @@ _bsc1(unsigned char *, gethwaddr, int, a)
>   _bsc1(char *, getbenv, char *, a)
>   #endif
>
> -void config_BSP(char *command, int len)
> +void __init config_BSP(char *command, int len)
>   {
>     unsigned char *p;
>
> diff --git a/arch/m68k/platform/68000/m68VZ328.c b/arch/m68k/platform/68000/m68VZ328.c
> index eb6964f..42e1ada 100644
> --- a/arch/m68k/platform/68000/m68VZ328.c
> +++ b/arch/m68k/platform/68000/m68VZ328.c
> @@ -14,6 +14,7 @@
>
>   /***************************************************************************/
>
> +#include <linux/init.h>
>   #include <linux/types.h>
>   #include <linux/kernel.h>
>   #include <linux/kd.h>
> @@ -175,7 +176,7 @@ static void init_hardware(char *command, int size)
>   #endif
>   /***************************************************************************/
>
> -void config_BSP(char *command, int size)
> +void __init config_BSP(char *command, int size)
>   {
>   	printk(KERN_INFO "68VZ328 DragonBallVZ support (c) 2001 Lineo, Inc.\n");
>
> diff --git a/arch/m68k/platform/68360/config.c b/arch/m68k/platform/68360/config.c
> index 9877cef..0570741 100644
> --- a/arch/m68k/platform/68360/config.c
> +++ b/arch/m68k/platform/68360/config.c
> @@ -11,6 +11,7 @@
>    */
>
>   #include <stdarg.h>
> +#include <linux/init.h>
>   #include <linux/types.h>
>   #include <linux/kernel.h>
>   #include <linux/mm.h>
> @@ -140,7 +141,7 @@ _bsc1(char *, getbenv, char *, a)
>   #endif
>
>
> -void config_BSP(char *command, int len)
> +void __init config_BSP(char *command, int len)
>   {
>     unsigned char *p;
>
>


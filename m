Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab3FQONW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 10:13:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53187 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab3FQONV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 10:13:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, ulli.kroll@googlemail.com,
        arm@kernel.org, Florian Fainelli <florian@openwrt.org>,
        Imre Kaloz <kaloz@openwrt.org>
Subject: Re: [PATCH] ARM: mm: cpu_fa526_do_idle: remove WFI
Date: Mon, 17 Jun 2013 16:14:03 +0200
Message-ID: <5020304.hteFFmWh1u@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1371476360-8751-1-git-send-email-jonas.jensen@gmail.com>
References: <1371476360-8751-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:kMbRaK4pRxuGIrhbBXrkGXuQoeZ+P2kZ/DfaEgeW22b
 gff1QVDVmFbKSN6VWCoAVgMkHh0ZUrDXjUfs7OCTpZTuT0h7oi
 rbqa4vu1lwTSakzwoQhugvuXFfgTqPgAfYWLQoLlsYmBxMtj9g
 plDd3kUihkHJnuQO5PgSRpAb5UpMZ+07kyaVPVKvAD4vI+ojYo
 jMMxm4SYA1m2PNcd57inbfnacE3IftGNV0jrsn9dNpRxOXEeqO
 QQI+dyivgt2haDdmXXILpvqQPnABkUsaYG93kfgi4JiLcH+5oJ
 53AHshnT0Y1JKrNvm3I6FpNHIp7dlSiw/GzfAnj1BgvSBoq/Lq
 uL8zTYmGL9/n+8O5Qlqo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 June 2013 15:39:20 Jonas Jensen wrote:
> As it was already suggested by Russell King and Arnd Bergmann ( https://lkml.org/lkml/2013/5/16/133 ), moxart and gemini seem to be the only platforms using CPU_FA526, and instead of pointing arm_pm_idle to an empty function from platform code, it makes sense to remove WFI code from the processor specific idle function.
> 
> Note: moxart boots and prints to UART without this patch, but input is broken.

Please make sure you have proper line wraps. Lines in checkin
comments should be no longer than 70 characters normally.

> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

Since this patch is independent from the actual platform support,
it should go through Russell's patch tracker at
http://www.arm.linux.org.uk/developer/patches/

>  arch/arm/mm/proc-fa526.S |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mm/proc-fa526.S b/arch/arm/mm/proc-fa526.S
> index d217e97..85280b1 100644
> --- a/arch/arm/mm/proc-fa526.S
> +++ b/arch/arm/mm/proc-fa526.S
> @@ -81,9 +81,7 @@ ENDPROC(cpu_fa526_reset)
>   */
>  	.align	4
>  ENTRY(cpu_fa526_do_idle)
> -	mcr	p15, 0, r0, c7, c0, 4		@ Wait for interrupt
> -	mov	pc, lr
> -
> +	nop
>  
>  ENTRY(cpu_fa526_dcache_clean_area)
>  1:	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry

Adding Imre and Florian to Cc for Gemini. They might have a comment
about this. I think we should delete arch/arm/mach-gemini/idle.c
after this as well.

	Arnd

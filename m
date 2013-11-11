Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab3KKLc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:32:28 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:36031 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab3KKLcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:32:21 -0500
Date: Mon, 11 Nov 2013 12:32:18 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] panic: improve panic_timeout calculation
Message-ID: <20131111113218.GF15810@gmail.com>
References: <1383871600-3831-1-git-send-email-felipe.contreras@gmail.com>
 <1383871600-3831-3-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383871600-3831-3-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Felipe Contreras <felipe.contreras@gmail.com> wrote:

> We want to calculate the blinks per second, and instead of making it 5 
> (1000 / (3600 / 18)), let's make it 4, so the user can see two blinks 
> per second.

Please use the customary changelog style we use in the kernel:

  " Current code does (A), this has a problem when (B).
    We can improve this doing (C), because (D)."

> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  kernel/panic.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/panic.c b/kernel/panic.c
> index 46e37ff..5a0bdaa 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -25,7 +25,7 @@
>  #include <linux/nmi.h>
>  
>  #define PANIC_TIMER_STEP 100
> -#define PANIC_BLINK_SPD 18
> +#define PANIC_BLINK_SPD 4

Please while at it also do another patch that renames it to a sane name, 
PANIC_BLINK_SPEED or so.

>  
>  int panic_on_oops = CONFIG_PANIC_ON_OOPS_VALUE;
>  static unsigned long tainted_mask;
> @@ -147,7 +147,7 @@ void panic(const char *fmt, ...)
>  			touch_nmi_watchdog();
>  			if (i >= i_next) {
>  				i += panic_blink(state ^= 1);
> -				i_next = i + 3600 / PANIC_BLINK_SPD;
> +				i_next = i + 1000 / PANIC_BLINK_SPD;

This changes a magic value to another magic value.

>  			}
>  			mdelay(PANIC_TIMER_STEP);
>  		}
> @@ -181,7 +181,7 @@ void panic(const char *fmt, ...)
>  		touch_softlockup_watchdog();
>  		if (i >= i_next) {
>  			i += panic_blink(state ^= 1);
> -			i_next = i + 3600 / PANIC_BLINK_SPD;
> +			i_next = i + 1000 / PANIC_BLINK_SPD;

Ditto.

Thanks,

	Ingo

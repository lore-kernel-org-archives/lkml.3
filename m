Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbaDQSbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 14:31:08 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58047 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaDQSa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 14:30:59 -0400
Message-ID: <53501DE2.2060202@codeaurora.org>
Date: Thu, 17 Apr 2014 11:30:58 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched_clock: Remove deprecated setup_sched_clock() API
References: <1397003599-22386-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1397003599-22386-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/14 17:33, Stephen Boyd wrote:
> Remove the 32-bit only setup_sched_clock() API now that all users
> have been converted to the 64-bit friendly sched_clock_register().
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>
> This is based on Linus' tree at a7963eb7f4c4 (Merge branch 'for_linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs, 2014-04-07)
> but technically this only needs to be based on 2d1eb87ae1e6 (Merge branch
> 'for-linus' of git://ftp.arm.linux.org.uk/~rmk/linux-arm, 2014-04-05) because
> the last user of setup_sched_clock() was in rmk's tree.

ping?

>
>  include/linux/sched_clock.h |  1 -
>  kernel/time/sched_clock.c   | 13 -------------
>  2 files changed, 14 deletions(-)
>
> diff --git a/include/linux/sched_clock.h b/include/linux/sched_clock.h
> index cddf0c2940b6..efa931c5cef1 100644
> --- a/include/linux/sched_clock.h
> +++ b/include/linux/sched_clock.h
> @@ -14,7 +14,6 @@ extern void sched_clock_postinit(void);
>  static inline void sched_clock_postinit(void) { }
>  #endif
>  
> -extern void setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate);
>  extern void sched_clock_register(u64 (*read)(void), int bits,
>  				 unsigned long rate);
>  
> diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
> index 4d23dc4d8139..445106d2c729 100644
> --- a/kernel/time/sched_clock.c
> +++ b/kernel/time/sched_clock.c
> @@ -49,13 +49,6 @@ static u64 notrace jiffy_sched_clock_read(void)
>  	return (u64)(jiffies - INITIAL_JIFFIES);
>  }
>  
> -static u32 __read_mostly (*read_sched_clock_32)(void);
> -
> -static u64 notrace read_sched_clock_32_wrapper(void)
> -{
> -	return read_sched_clock_32();
> -}
> -
>  static u64 __read_mostly (*read_sched_clock)(void) = jiffy_sched_clock_read;
>  
>  static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
> @@ -176,12 +169,6 @@ void __init sched_clock_register(u64 (*read)(void), int bits,
>  	pr_debug("Registered %pF as sched_clock source\n", read);
>  }
>  
> -void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
> -{
> -	read_sched_clock_32 = read;
> -	sched_clock_register(read_sched_clock_32_wrapper, bits, rate);
> -}
> -
>  void __init sched_clock_postinit(void)
>  {
>  	/*

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


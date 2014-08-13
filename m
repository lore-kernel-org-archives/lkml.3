Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaHMAUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 20:20:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:42513 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaHMAUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 20:20:22 -0400
Date: Wed, 13 Aug 2014 02:20:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] timekeeping: Another fix to the VSYSCALL_OLD
 update_vsyscall
In-Reply-To: <1407858749-15422-1-git-send-email-john.stultz@linaro.org>
Message-ID: <alpine.DEB.2.10.1408130216210.3323@nanos>
References: <1407858749-15422-1-git-send-email-john.stultz@linaro.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2014, John Stultz wrote:

> Benjamin Herrenschmidt pointed out that I firuther missed

s/firuther/further ?

> modifying update_vsyscall after the wall_to_mono value was
> changed to a timespec64. This causes issues on powerpc32,
> which expects a 32bit timespec.
> 
> This patch fixes the problem my properly converting from

s/my/by/ 

> a timespec64 to a timespec before passing the value on to
> the arch-specific vsyscall logic.

Other than that, please add my Reviewed-by, and send it to Linus
either as patch or pull request as I'm really in vacation mode NOW.

> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  kernel/time/timekeeping.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index f36b028..fb4a9c2 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -338,10 +338,11 @@ EXPORT_SYMBOL_GPL(ktime_get_mono_fast_ns);
>  
>  static inline void update_vsyscall(struct timekeeper *tk)
>  {
> -	struct timespec xt;
> +	struct timespec xt, wm;
>  
>  	xt = timespec64_to_timespec(tk_xtime(tk));
> -	update_vsyscall_old(&xt, &tk->wall_to_monotonic, tk->tkr.clock, tk->tkr.mult,
> +	wm = timespec64_to_timespec(tk->wall_to_monotonic);
> +	update_vsyscall_old(&xt, &wm, tk->tkr.clock, tk->tkr.mult,
>  			    tk->tkr.cycle_last);
>  }
>  
> -- 
> 1.9.1
> 
> 

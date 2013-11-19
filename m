Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab3KSIkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 03:40:13 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:61533 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3KSIkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 03:40:10 -0500
Date: Tue, 19 Nov 2013 09:40:06 +0100
From: Ingo Molnar <mingo@kernel.org>
To: akpm@linux-foundation.org
Cc: tglx@linutronix.de, hpa@zytor.com, mingo@elte.hu, sboyd@codeaurora.org,
        rmk@arm.linux.org.uk, voice.shen@atmel.com,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 1/3] sched_clock: document 4Mhz vs 1Mhz decision
Message-ID: <20131119084006.GC1243@gmail.com>
References: <20131115221529.43E8B1CA1A1@corp2gmr1-1.eem.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115221529.43E8B1CA1A1@corp2gmr1-1.eem.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:

> From: Stephen Boyd <sboyd@codeaurora.org>
> Subject: sched_clock: document 4Mhz vs 1Mhz decision
> 
> Bo Shen sent a patch to change this to 1Mhz instead of 4Mhz but according
> to Russell King the use of 4Mhz was intentional.  Add a comment to this
> effect so that others don't try to change the code as well.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Bo Shen <voice.shen@atmel.com>
> Cc: Russell King <rmk@arm.linux.org.uk>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/time/sched_clock.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff -puN kernel/time/sched_clock.c~sched_clock-document-4mhz-vs-1mhz-decision kernel/time/sched_clock.c
> --- a/kernel/time/sched_clock.c~sched_clock-document-4mhz-vs-1mhz-decision
> +++ a/kernel/time/sched_clock.c
> @@ -132,6 +132,10 @@ void __init sched_clock_register(u64 (*r
>  	clocks_calc_mult_shift(&cd.mult, &cd.shift, rate, NSEC_PER_SEC, 3600);
>  
>  	r = rate;
> +	/*
> +	 * Use 4MHz instead of 1MHz so that things like 1.832Mhz show as
> +	 * 1832Khz
> +	 */
>  	if (r >= 4000000) {
>  		r /= 1000000;
>  		r_unit = 'M';

Instead of magic precision cutoff limits the better solution would be 
to simply display not just decimal part but also the first 3 digits of 
the fractional part:

          1.123  Hz
	990.134 kHz
	  1.832 MHz
	 12.314 GHz

etc. - then every number could be displayed in its natural unit 
without magic precision limits.

It would also be mostly self-documenting.

Thanks,

	Ingo

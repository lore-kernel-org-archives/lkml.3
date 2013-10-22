Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab3JVUTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 16:19:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60510 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3JVUTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 16:19:03 -0400
Date: Tue, 22 Oct 2013 22:18:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, mingo@kernel.org
Subject: Re: [PATCH 06/11] asmlinkage: Make trace_hardirq visible
Message-ID: <20131022201848.GC2490@laptop.programming.kicks-ass.net>
References: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
 <1382458346-24811-7-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382458346-24811-7-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 09:12:21AM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Can be called from assembler code.
> 
> Cc: peterz@infradead.org
> Cc: mingo@kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  kernel/lockdep.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index d3749fe..d1a047d 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -2555,7 +2555,7 @@ static void __trace_hardirqs_on_caller(unsigned long ip)
>  	debug_atomic_inc(hardirqs_on_events);
>  }
>  
> -void trace_hardirqs_on_caller(unsigned long ip)
> +__visible void trace_hardirqs_on_caller(unsigned long ip)
>  {
>  	time_hardirqs_on(CALLER_ADDR0, ip);
>  

$sub talks about asmlinkage, yet here you insert __visible; 'sup?

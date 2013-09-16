Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab3IPKbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 06:31:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47128 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab3IPKbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 06:31:02 -0400
Date: Mon, 16 Sep 2013 12:30:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        linux-arch@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [gcv v4 05/38] percpu: Add preemption checks to __this_cpu ops
Message-ID: <20130916103052.GB29018@twins.programming.kicks-ass.net>
References: <20130903190014.794420260@linux.com>
 <00000140e5f56965-daead878-020f-4dd9-b239-5547db26f274-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140e5f56965-daead878-020f-4dd9-b239-5547db26f274-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 10:33:20PM +0000, Christoph Lameter wrote:
> We define a check function in order to avoid trouble with the
> include files. Then the higher level __this_cpu macros are
> modified to involve the check before any operation.
> 

So this_cpu_ptr() is the one with the check, and __this_cpu_ptr() is the
one without. But for the other this_cpu ops __this_cpu_$OP() is going to
be the one with a check and this_cpu_$OP() the one without?

Sounds like a bloody marvelous idea :/



> Index: linux/include/linux/percpu.h
> ===================================================================
> --- linux.orig/include/linux/percpu.h	2013-09-03 13:38:49.818888738 -0500
> +++ linux/include/linux/percpu.h	2013-09-03 13:38:49.810888819 -0500
> @@ -172,6 +172,12 @@ extern phys_addr_t per_cpu_ptr_to_phys(v
>  
>  extern void __bad_size_call_parameter(void);
>  
> +#ifdef CONFIG_PREEMPT
> +extern void this_cpu_preempt_check(void);
> +#else
> +static inline void this_cpu_preempt_check(void) { }
> +#endif

How about re-using debug_smp_processor_id() instead?

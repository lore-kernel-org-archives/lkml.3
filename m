Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab3IJN1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:27:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47090 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3IJN1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 09:27:34 -0400
Date: Tue, 10 Sep 2013 15:27:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 6/7] sched, x86: Provide a per-cpu preempt_count
 implementation
Message-ID: <20130910132724.GF31370@twins.programming.kicks-ass.net>
References: <20130910130811.507933095@infradead.org>
 <20130910132011.396291123@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910132011.396291123@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 03:08:17PM +0200, Peter Zijlstra wrote:
> @@ -1095,6 +1095,9 @@ DEFINE_PER_CPU(char *, irq_stack_ptr) =
>  
>  DEFINE_PER_CPU(unsigned int, irq_count) __visible = -1;
>  
> +DEFINE_PER_CPU(int, __preempt_count) = INIT_PREEMPT_COUNT;
> +EXPORT_PER_CPU_SYMBOL(__preempt_count);
> +

Note that afaict this patch takes away the reason irq_count exists.

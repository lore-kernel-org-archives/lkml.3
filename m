Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab3JPIrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:47:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48879 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760467Ab3JPIrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:47:12 -0400
Date: Wed, 16 Oct 2013 10:46:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH 5/6] net: __this_cpu_inc in route.c
Message-ID: <20131016084659.GS10651@twins.programming.kicks-ass.net>
References: <20131015174722.615394057@linux.com>
 <20131015174747.307585124@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015174747.307585124@linux.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 12:47:27PM -0500, Christoph Lameter wrote:
> The RT_CACHE_STAT_INC macro triggers the new preemption checks
> for __this_cpu ops
> 
> I do not see any other synchronization that would allow the use
> of a __this_cpu operation here however in commit
> dbd2915ce87e811165da0717f8e159276ebb803e Andrew justifies
> the use of raw_smp_processor_id() here because "we do not care"
> about races.
> 
> So lets use raw_cpu ops here and hope for the best. The use of
> __this_cpu op improves the situation already from what commit
> dbd2915ce87e811165da0717f8e159276ebb803e did since the single instruction
> emitted on x86 does not allow the race to occur anymore. However,
> non x86 platforms could still experience a race here.
> 

Are we sure all !x86 implementations will DTRT in that it will increment
some CPU and not get horribly confused? I suppose it would; but is
that a guarantee given someplace?

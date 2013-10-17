Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762960Ab3JQVNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:13:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35668 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762916Ab3JQVNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:13:30 -0400
Date: Thu, 17 Oct 2013 23:13:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] percpu: Add preemption checks to __this_cpu ops
Message-ID: <20131017211317.GZ10651@twins.programming.kicks-ass.net>
References: <20131015174722.615394057@linux.com>
 <20131015174747.813545438@linux.com>
 <20131016084920.GT10651@twins.programming.kicks-ass.net>
 <00000141c1d04300-e935e477-6669-4388-8109-c77064ee27e7-000000@email.amazonses.com>
 <20131016153603.GZ10651@twins.programming.kicks-ass.net>
 <00000141c1fae3ba-6b52fea1-74f9-42f7-b1db-70dda847e7f9-000000@email.amazonses.com>
 <20131016162537.GB10651@twins.programming.kicks-ass.net>
 <20131016183818.GD3364@laptop.programming.kicks-ass.net>
 <00000141c7de3c3e-51b4dd7b-901e-466e-829a-b1f7c4b9ec90-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000141c7de3c3e-51b4dd7b-901e-466e-829a-b1f7c4b9ec90-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 07:22:12PM +0000, Christoph Lameter wrote:
> On Wed, 16 Oct 2013, Peter Zijlstra wrote:
> > diff --git a/arch/x86/include/asm/preempt.h b/arch/x86/include/asm/preempt.h
> > index 8729723..95e3532 100644
> > --- a/arch/x86/include/asm/preempt.h
> > +++ b/arch/x86/include/asm/preempt.h
> > @@ -13,12 +13,12 @@ DECLARE_PER_CPU(int, __preempt_count);
> >   */
> >  static __always_inline int preempt_count(void)
> >  {
> > -	return __this_cpu_read_4(__preempt_count) & ~PREEMPT_NEED_RESCHED;
> > +	return raw_cpu_read_4(__preempt_count) & ~PREEMPT_NEED_RESCHED;
> >  }
> >
> >  static __always_inline void preempt_count_set(int pc)
> >  {
> > -	__this_cpu_write_4(__preempt_count, pc);
> > +	raw_cpu_write_4(__preempt_count, pc);
> >  }
> 
> Huh? What happened here? Why do we use the __this_cpu_read_4 here?
> This should be just raw_cpu_write()

Header inclusion hell; I could only easily get away with including
asm/percpu.h, so I had to use the _4 stuff.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab3JDIht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 04:37:49 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40013 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284Ab3JDIho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 04:37:44 -0400
Date: Fri, 4 Oct 2013 10:37:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, Steven Rostedt <srostedt@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [pchecks v2 2/2] percpu: Add preemption checks to __this_cpu ops
Message-ID: <20131004083741.GB1658@gmail.com>
References: <20131003182902.174251532@linux.com>
 <000001417f93fb74-f307f391-26a4-431a-8295-04c5319d1373-000000@email.amazonses.com>
 <20131004082728.GG3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004082728.GG3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> > @@ -39,8 +39,8 @@ notrace unsigned int debug_smp_processor
> >  	if (!printk_ratelimit())
> >  		goto out_enable;
> >  
> > -	printk(KERN_ERR "BUG: using smp_processor_id() in preemptible [%08x] "
> > -			"code: %s/%d\n",
> > +	printk(KERN_ERR "%s in preemptible [%08x] "
> > +			"code: %s/%d\n", what,
> >  			preempt_count() - 1, current->comm, current->pid);
> 
> I would argue for keeping the "BUG" string intact and in front of the
> %s.

Definitely.

Thanks,

	Ingo

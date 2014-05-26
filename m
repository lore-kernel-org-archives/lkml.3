Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaEZTT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:19:28 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46615 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaEZTT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:19:27 -0400
Date: Mon, 26 May 2014 21:19:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 3/5] irq_work: Implement remote queueing
Message-ID: <20140526191918.GA5444@laptop.programming.kicks-ass.net>
References: <1401028191-29756-1-git-send-email-fweisbec@gmail.com>
 <1401028191-29756-4-git-send-email-fweisbec@gmail.com>
 <20140526160224.GM30445@twins.programming.kicks-ass.net>
 <20140526165039.GE2066@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140526165039.GE2066@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 06:50:41PM +0200, Frederic Weisbecker wrote:
> On Mon, May 26, 2014 at 06:02:24PM +0200, Peter Zijlstra wrote:
> > On Sun, May 25, 2014 at 04:29:49PM +0200, Frederic Weisbecker wrote:
> > > +bool irq_work_queue_on(struct irq_work *work, int cpu)
> > > +{
> > > +	/* Only queue if not already pending */
> > > +	if (!irq_work_claim(work))
> > > +		return false;
> > > +
> > > +	/* All work should have been flushed before going offline */
> > > +	WARN_ON_ONCE(cpu_is_offline(cpu));
> > 	WARN_ON_ONCE(in_nmi());
> 
> But it's actually NMI safe, isn't it?

Deja-vu:

  lkml.kernel.org/r/20140514115406.GA11096@twins.programming.kicks-ass.net

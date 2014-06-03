Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbaFCO46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:56:58 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:51786 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbaFCO45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:56:57 -0400
Date: Tue, 3 Jun 2014 16:56:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/5] irq_work: Split raised and lazy lists
Message-ID: <20140603145651.GB23860@localhost.localdomain>
References: <1401806420-31018-1-git-send-email-fweisbec@gmail.com>
 <1401806420-31018-2-git-send-email-fweisbec@gmail.com>
 <20140603145442.GS30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603145442.GS30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 04:54:42PM +0200, Peter Zijlstra wrote:
> On Tue, Jun 03, 2014 at 04:40:16PM +0200, Frederic Weisbecker wrote:
> > @@ -90,10 +89,10 @@ EXPORT_SYMBOL_GPL(irq_work_queue);
> >  
> >  bool irq_work_needs_cpu(void)
> >  {
> > -	struct llist_head *this_list;
> > +	struct llist_head *list;
> >  
> > -	this_list = &__get_cpu_var(irq_work_list);
> > -	if (llist_empty(this_list))
> > +	list = &__get_cpu_var(lazy_list);
> > +	if (llist_empty(list))
> >  		return false;
> >  
> >  	/* All work should have been flushed before going offline */
> 
> Does this mean needs_cpu() only checks the lazy list? What about archs
> without the arch_irq_work_raise() function? They run the other list from
> the tick too.

Right, I'll fix that too.

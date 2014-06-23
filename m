Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbaFWS7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:59:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:44817 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720AbaFWS7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:59:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,532,1400050800"; 
   d="scan'208";a="562044177"
Subject: Re: [PATCH v2] sched: Fast idling of CPU when system is partially
 loaded
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, Jason Low <jason.low2@hp.com>,
        Davidlohr Bueson <davidlohr@hp.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20140623185006.GH13930@laptop.programming.kicks-ass.net>
References: <1402948127.2970.578.camel@schen9-DESK>
	 <20140623125233.GZ19860@laptop.programming.kicks-ass.net>
	 <1403541645.2970.599.camel@schen9-DESK>
	 <20140623185006.GH13930@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Jun 2014 11:59:40 -0700
Message-ID: <1403549980.2970.612.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 20:50 +0200, Peter Zijlstra wrote:
> On Mon, Jun 23, 2014 at 09:40:45AM -0700, Tim Chen wrote:
> 
> > > @@ -5886,7 +5886,7 @@ static inline void update_sg_lb_stats(st
> > >  
> > >  		sgs->group_load += load;
> > >  		sgs->sum_nr_running += rq->nr_running;
> > > -		if (overload && rq->nr_running > 1)
> > > +		if (rq->nr_running > 1)
> > >  			*overload = true;
> > >  #ifdef CONFIG_NUMA_BALANCING
> > >  		sgs->nr_numa_running += rq->nr_numa_running;
> 
> > With this change, we'll be returning the overload indicator 
> > that we don't use for non-root domains, which will be
> > extra work in sg_lb_stats as it loops through each rq checking
> > the nr_running to update the indicator.  I was hoping to avoid
> > that if possible.
> 
> What extra work? We already load nr_running and overloaded is on-stack
> and should be quite dirty already due to that.

Okay then.  I'll need to modify the v3 patch with the following bits:

-               /* only need to update overload indicator for root domain */
-               if (!env->sd->parent && rq->nr_running > 1)
+               if (rq->nr_running > 1)
                        *overload = true;

Just sent v3 patch out before your email reached me.

Tim


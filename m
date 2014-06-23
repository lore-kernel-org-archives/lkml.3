Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbaFWSuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:50:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:48769 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbaFWSuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:50:11 -0400
Date: Mon, 23 Jun 2014 20:50:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, Jason Low <jason.low2@hp.com>,
        Davidlohr Bueson <davidlohr@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sched: Fast idling of CPU when system is partially
 loaded
Message-ID: <20140623185006.GH13930@laptop.programming.kicks-ass.net>
References: <1402948127.2970.578.camel@schen9-DESK>
 <20140623125233.GZ19860@laptop.programming.kicks-ass.net>
 <1403541645.2970.599.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403541645.2970.599.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 09:40:45AM -0700, Tim Chen wrote:

> > @@ -5886,7 +5886,7 @@ static inline void update_sg_lb_stats(st
> >  
> >  		sgs->group_load += load;
> >  		sgs->sum_nr_running += rq->nr_running;
> > -		if (overload && rq->nr_running > 1)
> > +		if (rq->nr_running > 1)
> >  			*overload = true;
> >  #ifdef CONFIG_NUMA_BALANCING
> >  		sgs->nr_numa_running += rq->nr_numa_running;

> With this change, we'll be returning the overload indicator 
> that we don't use for non-root domains, which will be
> extra work in sg_lb_stats as it loops through each rq checking
> the nr_running to update the indicator.  I was hoping to avoid
> that if possible.

What extra work? We already load nr_running and overloaded is on-stack
and should be quite dirty already due to that.


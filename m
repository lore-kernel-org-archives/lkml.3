Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaJTPk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:40:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:13298 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751231AbaJTPkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:40:23 -0400
Date: Mon, 20 Oct 2014 11:40:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>, <linux-rt-users@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/7] wait.[ch]: Introduce the simple waitqueue (swait)
 implementation
Message-ID: <20141020114013.31e5137c@gandalf.local.home>
In-Reply-To: <20141020152144.GF24595@windriver.com>
References: <1413591782-23453-1-git-send-email-paul.gortmaker@windriver.com>
	<1413591782-23453-4-git-send-email-paul.gortmaker@windriver.com>
	<20141018213417.GE23531@worktop.programming.kicks-ass.net>
	<1413673519.30326.11.camel@pippen.local.home>
	<20141020152144.GF24595@windriver.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014 11:21:44 -0400
Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> > Right, and we should slap Paul for not showing up for it ;-)
> 
> And miss turkey day?  ;-)

Replace it with Alt Beer day!


> I'd like to hear more details on what you had in mind here, so I don't
> go chasing down the wrong road.  So the local list head gets all the
> items (via list_cut or moves?) and then that local list is spliced onto
> the (now temporarily empty) main list head? (presumably all under lock)

No. You move the items off the main list head and add it to the local
list and they never go back. Just start processing that local list.
Anything added to the main list after that will not get woken up by
that current wake_all call. It will need to be woken by another wake_up.

> 
> What would need to be done as an unwind at the end of processing the
> local list head before it disappears from existence?  Anything?

Not sure what you mean here.

> 
> > 
> > > 
> > > Also, I'm not entirely sure we want to do the cwait thing, it looks
> > > painful.
> > 
> > Yeah, I have to think about that some more too. I'm currently sitting in
> > the airport waiting for my final leg of my flight. After 18 hours of
> > travel, it is probably not too wise to review this work in my current
> > state ;-)
> 
> The alignment/parallel of existing mainline wait code seemed like the
> consensus back ages ago when this was being discussed on IRC, but if
> that has since changed, then I can adapt or abandon as required.  I long
> ago learned that the time spent on something has no correlation to its
> fitness or probability of being ready for addition to mainline.  :-)

heh, yeah. I'm guessing the point of all that is that anyone using the
wake_queue() will default to the simple version? And then one would
have to specify the complex version explicitly? But to do that we make
all these funny steps?  May be OK, I still haven't spent much thought
on it.

-- Steve

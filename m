Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab3ESQSv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 12:18:51 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:38241 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3ESQSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 12:18:49 -0400
Date: Sun, 19 May 2013 09:18:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] nohz: Disable LOCKUP_DETECTOR when NO_HZ_FULL is
 enabled
Message-ID: <20130519161843.GI4006@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1368547372-21011-2-git-send-email-fweisbec@gmail.com>
 <20130515083729.GC10510@laptop.programming.kicks-ass.net>
 <20130515150652.GP23604@redhat.com>
 <1368631622.6828.69.camel@gandalf.local.home>
 <20130515165915.GE13916@laptop.home>
 <1368637441.6828.70.camel@gandalf.local.home>
 <20130516081027.GD19669@dyad.programming.kicks-ass.net>
 <20130516150706.GY4442@linux.vnet.ibm.com>
 <20130516175602.GL19669@dyad.programming.kicks-ass.net>
 <1368729178.6828.105.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368729178.6828.105.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051916-3620-0000-0000-000002919952
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 02:32:58PM -0400, Steven Rostedt wrote:
> On Thu, 2013-05-16 at 19:56 +0200, Peter Zijlstra wrote:
> 
> > I suppose the fundamental question was: will receiving NMIs negate NO_HZ_FULL's
> > functionality? That is, will the getting of NMIs make us drop out of NO_HZ_FULL
> > and re-enable all sorts of things?
> 
> It shouldn't. The nmi_enter() notifies RCU that it can no longer ignore
> this CPU, where as nmi_enter() tells it that it can ignore it, as it has
> re-entered user space.
> 
> > 
> > Because clearly RCU needs to exit from EQS, which might (or might not) mean
> > leaving NO_HZ_FULL.
> 
> Yep, but the two are pretty much agnostic from each other.
> 
> We only need to leave NO_HZ_FULL if RCU (or anything for that matter)
> required having a tick again. But as Paul said, getting an NMI in idle
> wont restart the tick, so there's no need to restart it here either.
> 
> Now if an NMI were to do a call_rcu() then it would require a tick. But
> NMIs doing call_rcu() has much bigger issues to worry about ;-)

Someone invoking call_rcu() from an NMI handler will get what they deserve,
good and hard!  ;-)

							Thanx, Paul

> -- Steve
> 
> > 
> > I'm not entirely up-to-date on those details.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


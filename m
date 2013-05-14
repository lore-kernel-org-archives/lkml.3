Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740Ab3ENOx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:53:28 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:48475
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755664Ab3ENOx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:53:27 -0400
Date: Tue, 14 May 2013 16:51:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 6/7] rcu: Drive quiescent-state-forcing
 delay from HZ
Message-ID: <20130514145119.GC19669@dyad.programming.kicks-ass.net>
References: <1365808754-20762-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1365808754-20762-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130412235401.GA8140@jtriplet-mobl1>
 <20130413063804.GV29861@linux.vnet.ibm.com>
 <20130413181800.GA12096@leaf>
 <20130413193425.GY29861@linux.vnet.ibm.com>
 <20130413195336.GA14799@leaf>
 <20130413220943.GB29861@linux.vnet.ibm.com>
 <20130514122049.GH15942@dyad.programming.kicks-ass.net>
 <20130514141245.GA4442@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130514141245.GA4442@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In theory, yes.  In practice, this requires lots of lock acquisitions
> and releases on large systems, including some global locks.  The weight
> could be reduced, but...
> 
> What I would like to do instead would be to specify expedited grace
> periods during boot.

But why, surely going idle without any RCU callbacks isn't completely unheard
of, even outside of the boot process?

Being able to quickly drop out of the RCU state machinery would be a good thing IMO.

>  The challenge here appears to be somehow telling
> RCU when boot is done.  The APIs are there from an RCU viewpoint:  boot
> with rcupdate.rcu_expedited=1, then, once boot is complete (whatever
> that means on your platform) "echo 0 > /sys/kernel/rcu_expedited".

Ha, and here you assume userspace is sane and co-operative. Fail in my book ;-)

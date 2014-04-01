Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbaDARW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 13:22:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbaDARWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 13:22:55 -0400
Date: Tue, 1 Apr 2014 13:22:44 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: rcu_prempt stalls / lockup
Message-ID: <20140401172244.GA10363@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20140331230241.GA30019@redhat.com>
 <20140331232220.GP4284@linux.vnet.ibm.com>
 <20140331233552.GB30019@redhat.com>
 <20140401004801.GQ4284@linux.vnet.ibm.com>
 <20140401150849.GA14757@redhat.com>
 <20140401153032.GT4284@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140401153032.GT4284@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 08:30:32AM -0700, Paul E. McKenney wrote:
 > > [14403.765300] INFO: rcu_preempt detected stalls on CPUs/tasks:
 > > [14403.766405]  (detected by 0, t=260067 jiffies, g=449892, c=449891, q=0)
 > > and on and on..
 > > 
 > > so kernel space still works like before, but userspace is locked up.
 > 
 > Interesting.  I suspect that if you reverted the rest of this merge
 > window's RCU patches, you would get the same result.
 > 
 > >  > If that doesn't work, I will need to put together some diagnostic patches.
 > >  > Starting with the one below.
 > > 
 > > bugger, I forgot to apply this last night. I'll do it on the next run.
 > 
 > But let's see what this shows first.

[ 1173.923463] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 1173.924457] 	(detected by 0, t=6502 jiffies, g=47728, c=47727, q=0)
[ 1173.925199] INFO: Stall ended before state dump start, gp_kthread state: 0x2
[ 1368.859744] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 1368.860754] 	(detected by 0, t=26007 jiffies, g=47728, c=47727, q=0)
[ 1368.861559] INFO: Stall ended before state dump start, gp_kthread state: 0x2
[ 1563.796416] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 1563.797426] 	(detected by 0, t=45512 jiffies, g=47728, c=47727, q=0)
[ 1563.798293] INFO: Stall ended before state dump start, gp_kthread state: 0x2
[ 1758.733747] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 1758.734725] 	(detected by 0, t=65017 jiffies, g=47728, c=47727, q=0)
[ 1758.735526] INFO: Stall ended before state dump start, gp_kthread state: 0x2
[ 1953.670944] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 1953.671932] 	(detected by 0, t=84522 jiffies, g=47728, c=47727, q=0)
[ 1953.672735] INFO: Stall ended before state dump start, gp_kthread state: 0x2
[ 2148.608132] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 2148.609140] 	(detected by 0, t=104027 jiffies, g=47728, c=47727, q=0)
etc etc.

	Dave
 

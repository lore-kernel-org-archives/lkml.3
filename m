Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaJ0VRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 17:17:22 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:60302 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbaJ0VRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 17:17:21 -0400
Date: Mon, 27 Oct 2014 14:13:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        htejun@gmail.com
Subject: Re: rcu_preempt detected stalls.
Message-ID: <20141027211329.GJ5718@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141013173504.GA27955@redhat.com>
 <543DDD5E.9080602@oracle.com>
 <20141023183917.GX4977@linux.vnet.ibm.com>
 <54494F2F.6020005@oracle.com>
 <20141023195808.GB4977@linux.vnet.ibm.com>
 <544A45F8.2030207@oracle.com>
 <20141024161337.GQ4977@linux.vnet.ibm.com>
 <544A80B3.9070800@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544A80B3.9070800@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102721-0033-0000-0000-0000027BA589
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 12:39:15PM -0400, Sasha Levin wrote:
> On 10/24/2014 12:13 PM, Paul E. McKenney wrote:
> > On Fri, Oct 24, 2014 at 08:28:40AM -0400, Sasha Levin wrote:
> >> > On 10/23/2014 03:58 PM, Paul E. McKenney wrote:
> >>> > > On Thu, Oct 23, 2014 at 02:55:43PM -0400, Sasha Levin wrote:
> >>>>> > >> > On 10/23/2014 02:39 PM, Paul E. McKenney wrote:
> >>>>>>> > >>> > > On Tue, Oct 14, 2014 at 10:35:10PM -0400, Sasha Levin wrote:
> >>>>>>>>> > >>>> > >> On 10/13/2014 01:35 PM, Dave Jones wrote:
> >>>>>>>>>>> > >>>>> > >>> oday in "rcu stall while fuzzing" news:
> >>>>>>>>>>> > >>>>> > >>>
> >>>>>>>>>>> > >>>>> > >>> INFO: rcu_preempt detected stalls on CPUs/tasks:
> >>>>>>>>>>> > >>>>> > >>> 	Tasks blocked on level-0 rcu_node (CPUs 0-3): P766 P646
> >>>>>>>>>>> > >>>>> > >>> 	Tasks blocked on level-0 rcu_node (CPUs 0-3): P766 P646
> >>>>>>>>>>> > >>>>> > >>> 	(detected by 0, t=6502 jiffies, g=75434, c=75433, q=0)
> >>>>>>>>> > >>>> > >>
> >>>>>>>>> > >>>> > >> I've complained about RCU stalls couple days ago (in a different context)
> >>>>>>>>> > >>>> > >> on -next. I guess whatever causing them made it into Linus's tree?
> >>>>>>>>> > >>>> > >>
> >>>>>>>>> > >>>> > >> https://lkml.org/lkml/2014/10/11/64
> >>>>>>> > >>> > > 
> >>>>>>> > >>> > > And on that one, I must confess that I don't see where the RCU read-side
> >>>>>>> > >>> > > critical section might be.
> >>>>>>> > >>> > > 
> >>>>>>> > >>> > > Hmmm...  Maybe someone forgot to put an rcu_read_unlock() somewhere.
> >>>>>>> > >>> > > Can you reproduce this with CONFIG_PROVE_RCU=y?
> >>>>> > >> > 
> >>>>> > >> > Paul, if that was directed to me - Yes, I see stalls with CONFIG_PROVE_RCU
> >>>>> > >> > set and nothing else is showing up before/after that.
> >>> > > Indeed it was directed to you.  ;-)
> >>> > > 
> >>> > > Does the following crude diagnostic patch turn up anything?
> >> > 
> >> > Nope, seeing stalls but not seeing that pr_err() you added.
> > OK, color me confused.  Could you please send me the full dmesg or a
> > pointer to it?
> 
> Attached.

Thank you!  I would complain about the FAULT_INJECTION messages, but
they don't appear to be happening all that frequently.

The stack dumps do look different here.  I suspect that this is a real
issue in the VM code.

							Thanx, Paul


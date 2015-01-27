Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbbA0XRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:17:08 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:35859 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbbA0XRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:17:06 -0500
Date: Tue, 27 Jan 2015 15:16:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "davej@codemonkey.org.uk >> Dave Jones" <davej@codemonkey.org.uk>
Subject: Re: rcu, sched: WARNING: CPU: 30 PID: 23771 at
 kernel/rcu/tree_plugin.h:337 rcu_read_unlock_special+0x369/0x550()
Message-ID: <20150127231659.GG19109@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20150123035158.GP9719@linux.vnet.ibm.com>
 <54C1C7D2.906@oracle.com>
 <54C1C899.8000106@oracle.com>
 <20150123065542.GQ9719@linux.vnet.ibm.com>
 <20150123093644.GA11175@linux.vnet.ibm.com>
 <54C300DD.9070608@cn.fujitsu.com>
 <20150124211834.GD9719@linux.vnet.ibm.com>
 <54C5A184.20105@cn.fujitsu.com>
 <20150127220329.GF19109@linux.vnet.ibm.com>
 <54C80C55.2070908@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C80C55.2070908@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012723-0005-0000-0000-0000085B0857
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 05:08:21PM -0500, Sasha Levin wrote:
> On 01/27/2015 05:03 PM, Paul E. McKenney wrote:
> > On Mon, Jan 26, 2015 at 10:08:04AM +0800, Lai Jiangshan wrote:
> >> > On 01/25/2015 05:18 AM, Paul E. McKenney wrote:
> >> > 
> >>> > > 
> >>> > > Good point!  In my scenario, CPU 0 would not yet have switched away from
> >>> > > Task A.  Hmmm...  Yet Sasha really does see this failure.  Will give it
> >>> > > some more thought.
> >>> > > 
> >>> > > Any ideas?
> >> > 
> >> > I don't known which commit was merged from the rcu-git-tree in Sasha's test
> >> > I try to review it.
> > If I had to guess, it would be 1d082fd06188 (Remove local_irq_disable()
> > in rcu_preempt_note_context_switch()), though his finding this might be
> > more directly related to increases in trinity's levels of stress.
> 
> Quick update from my end: I've stopped seeing this warning, but I've also stopped
> seeing warnings for the other RCU issue I've reported (https://lkml.org/lkml/2015/1/22/676)
> so I'm slightly unhappy about that.

Another approach would be to remove that patch and then revert 1d082fd06188.

Either way, may I have your Tested-by?

> >> > We can fallback to git-bitsect if the reviews fails.
> > One (very unlikely) possibility is that Sasha's compiler is ignoring the
> > barrier() in rcu_preempt_qs().
> 
> I'm actually running the latest gcc (trunk) as well, so it's very possible that it was
> doing something stupid.

Hmmmm...  Could you please send along the assembly output for rcu_preempt_qs()?

							Thanx, Paul


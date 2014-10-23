Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbaJWSnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 14:43:12 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47324 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533AbaJWSnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 14:43:10 -0400
Date: Thu, 23 Oct 2014 11:39:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        htejun@gmail.com
Subject: Re: rcu_preempt detected stalls.
Message-ID: <20141023183917.GX4977@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141013173504.GA27955@redhat.com>
 <543DDD5E.9080602@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543DDD5E.9080602@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102318-0033-0000-0000-000000D07616
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 10:35:10PM -0400, Sasha Levin wrote:
> On 10/13/2014 01:35 PM, Dave Jones wrote:
> > oday in "rcu stall while fuzzing" news:
> > 
> > INFO: rcu_preempt detected stalls on CPUs/tasks:
> > 	Tasks blocked on level-0 rcu_node (CPUs 0-3): P766 P646
> > 	Tasks blocked on level-0 rcu_node (CPUs 0-3): P766 P646
> > 	(detected by 0, t=6502 jiffies, g=75434, c=75433, q=0)
> 
> I've complained about RCU stalls couple days ago (in a different context)
> on -next. I guess whatever causing them made it into Linus's tree?
> 
> https://lkml.org/lkml/2014/10/11/64

And on that one, I must confess that I don't see where the RCU read-side
critical section might be.

Hmmm...  Maybe someone forgot to put an rcu_read_unlock() somewhere.
Can you reproduce this with CONFIG_PROVE_RCU=y?

							Thanx, Paul


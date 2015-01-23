Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbbAWWyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 17:54:22 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52614 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbbAWWyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 17:54:20 -0500
Date: Fri, 23 Jan 2015 14:54:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "davej@codemonkey.org.uk >> Dave Jones" <davej@codemonkey.org.uk>
Subject: Re: rcu, sched: WARNING: CPU: 30 PID: 23771 at
 kernel/rcu/tree_plugin.h:337 rcu_read_unlock_special+0x369/0x550()
Message-ID: <20150123225411.GZ9719@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20150121025754.GV9719@linux.vnet.ibm.com>
 <54BFC979.8040107@oracle.com>
 <20150122004305.GJ9719@linux.vnet.ibm.com>
 <54C1BFFD.9060707@oracle.com>
 <20150123035158.GP9719@linux.vnet.ibm.com>
 <54C1C7D2.906@oracle.com>
 <54C1C899.8000106@oracle.com>
 <20150123065542.GQ9719@linux.vnet.ibm.com>
 <20150123093644.GA11175@linux.vnet.ibm.com>
 <54C2C278.1000608@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C2C278.1000608@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012322-0029-0000-0000-000001C9FE7E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 04:51:52PM -0500, Sasha Levin wrote:
> On 01/23/2015 04:36 AM, Paul E. McKenney wrote:
> > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > index 8669de884445..ec99dc16aa38 100644
> > --- a/kernel/rcu/tree_plugin.h
> > +++ b/kernel/rcu/tree_plugin.h
> > @@ -322,6 +322,7 @@ void rcu_read_unlock_special(struct task_struct *t)
> >  	special = t->rcu_read_unlock_special;
> >  	if (special.b.need_qs) {
> >  		rcu_preempt_qs();
> > +		t->rcu_read_unlock_special.need_qs = false;
> 
> It didn't compile, I've used:
> 
> 		t->rcu_read_unlock_special.b.need_qs = false;

Apologies, I should have marked it "untested".  Good show on finding
the correct fix.

But does your fixed version help?  ;-)

							Thanx, Paul


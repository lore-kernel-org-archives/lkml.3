Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbaEOR12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:27:28 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:39718 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaEOR10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:27:26 -0400
Message-ID: <1400174841.18229.6.camel@marge.simpson.net>
Subject: Re: [PATCH] sched/rt: don't try to balance rt_runtime when it is
 futile
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 15 May 2014 19:27:21 +0200
In-Reply-To: <20140515144553.GZ4570@linux.vnet.ibm.com>
References: <1400080115-12339-1-git-send-email-paul.gortmaker@windriver.com>
	 <20140514154459.GE4570@linux.vnet.ibm.com>
	 <1400123931.5175.38.camel@marge.simpson.net>
	 <20140515144553.GZ4570@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-15 at 07:45 -0700, Paul E. McKenney wrote: 
> On Thu, May 15, 2014 at 05:18:51AM +0200, Mike Galbraith wrote:
> > On Wed, 2014-05-14 at 08:44 -0700, Paul E. McKenney wrote:
> > 
> > > In practice, not sure how much testing CONFIG_NO_HZ_FULL=y has received
> > > for -rt kernels in production environments.
> > 
> > I took 3.14-rt out for a quick spin on my 64 core box, it didn't work at
> > all with 60 cores isolated.  I didn't have time to rummage, but it looks
> > like there are still bugs to squash. 
> > 
> > Biggest problem with CONFIG_NO_HZ_FULL is the price tag.  It just raped
> > fast mover performance last time I measured.
> 
> I do have a report of the RCU grace-period kthreads (rcu_preempt,
> rcu_sched, and rcu_bh) consuming excessive CPU time on large boxes,
> but this is for workloads with lots of threads and context switches.
> 
> Whether relevant or not to your situation, working on it...

RCU signal was swamped by accounting.

-Mike


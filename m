Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935304AbaH0RIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:08:32 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:47105 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934929AbaH0RIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:08:30 -0400
Date: Wed, 27 Aug 2014 10:08:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <pranith@gatech.edu>
Cc: Amit Shah <amit.shah@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, dvhart@linux.intel.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Silas Boyd-Wickizer <sbw@mit.edu>
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Parallelize and economize NOCB
 kthread wakeups
Message-ID: <20140827170824.GB2663@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAJhHMCC6XUo0erp6mPyjiz5614DQq_+gfVaLR5s9YZkP=jPVCw@mail.gmail.com>
 <20140827044350.GD13052@grmbl.mre>
 <20140827162113.GA2663@linux.vnet.ibm.com>
 <CAJhHMCBhhObL9hb9P_BCLBiVxn5z5MHawk=Xs=VMx2EqpnzUHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCBhhObL9hb9P_BCLBiVxn5z5MHawk=Xs=VMx2EqpnzUHA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082717-1542-0000-0000-000004565541
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 12:43:01PM -0400, Pranith Kumar wrote:
> On Wed, Aug 27, 2014 at 12:21 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Wed, Aug 27, 2014 at 10:13:50AM +0530, Amit Shah wrote:
> 
> >>
> >> Yes, this patch helps my case as well.
> >
> > Very good!!!
> >
> > Pranith, I can take this patch, but would you be willing to invert
> > the sense of ->nocb_leader_wake (e.g., call it ->nocb_leader_sleep or
> > some such)?  This field is only used in eight places in the source code.
> >
> > The idea is that inverting the sense of the field allows the normal C
> > initialization of zero to properly initialize this field, plus it gets
> > rid of a few lines of code.
> 
> Sure, that is indeed a good idea. I will send a new patch.

Very good, looking forward to seeing it!

							Thanx, Paul


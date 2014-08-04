Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaHDT2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:28:20 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:52340 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaHDT2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:28:19 -0400
Date: Mon, 4 Aug 2014 12:28:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140804192810.GR8101@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140802145616.GA18195@redhat.com>
 <20140802225757.GB8101@linux.vnet.ibm.com>
 <20140803133318.GB671@redhat.com>
 <20140803220535.GH8101@linux.vnet.ibm.com>
 <20140804133221.GC18722@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804133221.GC18722@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080419-9332-0000-0000-00000196C5FF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 03:32:21PM +0200, Oleg Nesterov wrote:
> On 08/03, Paul E. McKenney wrote:
> >
> > On Sun, Aug 03, 2014 at 03:33:18PM +0200, Oleg Nesterov wrote:
> > > It seems that you need another global list, a task should be visible on that
> > > list until exit_rcu().
> >
> > As in create another global list that all tasks are added to when created
> > and then remved from when they exit?
> 
> This is what I meant, although I hoped there is a better solution. The obvious
> problem is locking.
> 
> And at least Lai's idea looks certainly better to me.

OK, so I checked out my earlier concern about the group leader going away.
It looks like the group leader now sticks around until all threads in
the group have exited, which is a nice change from the behavior I was
(perhaps incorrectly) recalling!

							Thanx, Paul


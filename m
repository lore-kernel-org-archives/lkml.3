Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab3IIWeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 18:34:37 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57629 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755667Ab3IIWeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 18:34:36 -0400
Date: Mon, 9 Sep 2013 15:34:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909223426.GM3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130909134505.GF16280@somewhere>
 <20130909135656.GT3966@linux.vnet.ibm.com>
 <20130909101629.32df27a2@gandalf.local.home>
 <20130909161708.GX3966@linux.vnet.ibm.com>
 <20130909123422.7936e868@gandalf.local.home>
 <20130909165836.GB3966@linux.vnet.ibm.com>
 <20130909172908.GA31239@Krystal>
 <20130909175656.GF3966@linux.vnet.ibm.com>
 <20130909214026.GA8830@Krystal>
 <20130909175917.794b19bd@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909175917.794b19bd@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090922-0320-0000-0000-000000F0B292
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 05:59:17PM -0400, Steven Rostedt wrote:
> On Mon, 9 Sep 2013 17:40:26 -0400
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > Agreed. So how about rcu_is_online() ?
> 
> Nope, what about all_your_base_are_belong_to_rcu()?

Let's see if I can remember the candidates...

	rcu_is_cpu_idle() # reversed sense from the others
	rcu_is_ignored() # reversed sense from the others
	rcu_is_not_active() # reversed sense from the others
	rcu_is_watching_cpu()
	rcu_read_check()
	rcu_is_active()
	rcu_is_active_local()
	rcu_is_online()
	rcu_is_watching_task()
	rcu_is_watching_thread()
	rcu_is_watching_you()
	all_your_base_are_belong_to_rcu()
	rcu_is_active_loco()
	rcu_kilroy_was_here()

Maybe I should just lock them all in a room overnight and see which
are still alive in the morning.

							Thanx, Paul


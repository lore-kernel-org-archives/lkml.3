Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbaFTVYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 17:24:31 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46881 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102AbaFTVYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 17:24:30 -0400
Date: Fri, 20 Jun 2014 14:24:23 -0700
From: josh@joshtriplett.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/5] Fix for cond_resched performance
 regression
Message-ID: <20140620212423.GA22886@cloud>
References: <20140620183249.GA6325@linux.vnet.ibm.com>
 <20140620191236.GA10340@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620191236.GA10340@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 12:12:36PM -0700, Paul E. McKenney wrote:
> o	Make cond_resched() a no-op for PREEMPT=y.  This might well turn
> 	out to be a good thing, but it doesn't help give RCU the quiescent
> 	states that it needs.

What about doing this, together with letting the fqs logic poke
un-quiesced kernel code as needed?  That way, rather than having
cond_resched do any work, you have the fqs logic recognize that a
particular CPU has gone too long without quiescing, without disturbing
that CPU at all if it hasn't gone too long.

- Josh Triplett

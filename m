Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbaFWNvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:51:16 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:58892 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753943AbaFWNvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:51:12 -0400
Date: Mon, 23 Jun 2014 08:51:08 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, dave.hansen@intel.com, ak@linux.intel.com,
        umgwanakikbuti@gmail.com
Subject: Re: [PATCH tip/core/rcu] Reduce overhead of cond_resched() checks
 for RCU
In-Reply-To: <20140623062615.GB19860@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.11.1406230848540.2892@gentwo.org>
References: <20140621025958.GA7185@linux.vnet.ibm.com> <20140623062615.GB19860@laptop.programming.kicks-ass.net>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2014, Peter Zijlstra wrote:

> On the topic of these threads; I recently noticed RCU grew a metric ton
> of them, I found some 75 rcu kthreads on my box, wth up with that?

Would kworker threads work for rcu? That would also avoid the shifting
around of RCU threads for NOHZ configurations (which seems to have to be
done manually right now). The kworker subsystem work that allows
restriction to non NOHZ hardware threads would then also allow the
shifting of the rcu threads which would simplify the whole endeavor.




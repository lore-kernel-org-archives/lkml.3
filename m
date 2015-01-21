Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbbAUKIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:08:14 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:39063 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbbAUKII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:08:08 -0500
Date: Wed, 21 Jan 2015 02:07:50 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: [PATCH tip/core/rcu 0/7] Post RCU callbacks at early boot
Message-ID: <20150121100750.GA22883@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012110-8236-0000-0000-000008CAAD83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!  

This series, probably for v3.21, contains changes that allow RCU callbacks
to be posted at very early boot, as in before rcu_init() is called.
This was requested by the tracing folks.  This series applies against
tip/core/rcu, and probably not against current mainline.

The patches in this series are as follows:

1.	Abstract initialization of callback lists.

2.	Wire up the rcu_state structures' ->rda pointers at compile time.

3.	Prevent early boot callbacks from splatting.

4.	Refine diagnostics for lacking an rcuo kthread for no-CBs
	CPUs that have callbacks posted.

5.	Avoid clobbering lists of early boot callbacks.

6.	Move early boot callbacks as needed by no-CBs CPUs.

7.	Move early boot callbacks tests to beginning of rcu_init().

This passes modest rcutorture testing, but is probably missing a corner
case or two.

							Thanx, Paul

------------------------------------------------------------------------

 b/kernel/rcu/tree.c        |   52 ++++++++++++++++++++++++++++++++-------------
 b/kernel/rcu/tree_plugin.h |   27 ++++++++++++-----------
 2 files changed, 51 insertions(+), 28 deletions(-)


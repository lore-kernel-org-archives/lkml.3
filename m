Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab3ETOaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:30:19 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:60307 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550Ab3ETO3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:29:05 -0400
Date: Mon, 20 May 2013 07:28:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/6] v2 RCU fixes for 3.11
Message-ID: <20130520142819.GA27123@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-5406-0000-0000-000008A72B3A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1-2.	Convert remaining printk() calls to pr_*().

3.	Remove "Experimental" flags from old RCU Kconfig options.

4.	Automatically tune defaults for delays between attempts to
	force quiescent states.

5.	Merge adjacent identical #ifdefs.

6.	Apply Dave Jones's NOCB Kconfig help feedback.

Changes since v2:

o	Adaptive-ticks-CPU-kick patch dropped from this series and
	added to Frederic Weisbecker's adaptive-ticks patchset.

o	Patch to avoid allocating bootmem from rcu_init() was applied
	to 3.10 due to the number of people running into the corresponding
	splat.

o	Changed force-quiescent-state delay computation to use impulse
	functions, as suggested by Josh Triplett.

o	Added Dave Jones's NOCB Kconfig help patch.

							Thanx, Paul

 b/init/Kconfig            |   36 +++++++++++++++++++++---------
 b/kernel/rcupdate.c       |    3 --
 b/kernel/rcutree.c        |   24 +++++++++++++++-----
 b/kernel/rcutree.h        |   15 ++++++++----
 b/kernel/rcutree_plugin.h |   55 ++++++++++++++++++++++------------------------
 5 files changed, 82 insertions(+), 51 deletions(-)


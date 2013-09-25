Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab3IYB17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:27:59 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43314 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab3IYB14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:27:56 -0400
Date: Tue, 24 Sep 2013 18:27:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/11] Fixes for 3.13
Message-ID: <20130925012750.GA30601@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-6688-0000-0000-000001F8A8FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides the following miscellaneous fixes:

1.	Place a preemption point in do_mlockall().

2.	Use proper cpp macro for ->gp_flags instead of the constant "1".

3.	Convert a number of local functions to static.

4.	Fix a dubious "if" condition to use "||" rather than "|"
	(we were getting lucky...).

5.	Make list_splice_init_rcu() account for RCU readers.

6.	Replace __get_cpu_var() uses, courtesy of Christoph Lameter.

7.	Silence an unused-variables warning in rcu_eqs_enter_common()
	and rcu_eqs_exit_common().

8.	Micro-optimize rcu_cpu_has_callbacks().

9.	Reject memory-order-induced stall-warning false positives.

10.	Apply tracepoint_string() to rcutiny's trace events.

11.	Avoid a CONFIG_RCU_NOCB_CPU_ALL=y panic on systems with sparse
	CPU numbering, courtesy of Kirill Tkhai.

							Thanx, Paul


 b/include/linux/rculist.h |   23 +++++++++-
 b/kernel/rcu.h            |    7 +++
 b/kernel/rcupdate.c       |    2 
 b/kernel/rcutiny.c        |   17 ++++----
 b/kernel/rcutree.c        |   97 ++++++++++++++++++++++++++++++----------------
 b/kernel/rcutree_plugin.h |   23 ++++++----
 b/mm/mlock.c              |    1 
 7 files changed, 119 insertions(+), 51 deletions(-)


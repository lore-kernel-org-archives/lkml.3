Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaBQV0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:26:32 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:41457 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaBQV0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:26:31 -0500
Date: Mon, 17 Feb 2014 13:26:25 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/6] Documentation changes for 3.15
Message-ID: <20140217212625.GA4083@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021721-7164-0000-0000-00000626648D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides a variety of documentation updates:

1.	Update the documentation on actions to take to avoid frenetic
	call_rcu() invocations from exhausting memory, including a mention
	of internal-to-RCU avoidance measures.

2.	Add a note to Documentation/memory-barriers.txt stating that
	ACCESS_ONCE() provides cache coherence for accesses to any
	single given variable.

3.	Add an explicit statement that in control dependencies, the
	condition must include the load in question.

4.	Add WQ_SYSFS workqueues as a work-offloading option in
	Documentation/kernel-per-CPU-kthreads.txt.

5.	It turns out that some types of control dependencies require
	memory barriers, most notably when the exact same store is
	at the beginning of both the then-clause and the else-clause.
	Document this.

6.	Fixups to RTFP.txt

							Thanx, Paul

------------------------------------------------------------------------

 Documentation/memory-barriers.txt           |   29 +++--
 b/Documentation/RCU/RTFP.txt                |  149 +++++++++++++++++++++++-----
 b/Documentation/RCU/checklist.txt           |   19 ++-
 b/Documentation/kernel-per-CPU-kthreads.txt |   13 ++
 b/Documentation/memory-barriers.txt         |   17 +++
 5 files changed, 189 insertions(+), 38 deletions(-)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab3LDWqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 17:46:38 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:45068 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab3LDWqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 17:46:36 -0500
Date: Wed, 4 Dec 2013 14:46:28 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: [PATCH v4 tip/core/locking 0/4] Memory-barrier documentation updates
Message-ID: <20131204224628.GA30159@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120422-7164-0000-0000-000003F23335
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series applies some long-needed updates to memory-barriers.txt:

1.	Add ACCESS_ONCE() calls where needed to ensure their inclusion
	in code copy-and-pasted from this file.

2.	Add long atomic examples alongside the existing atomics.

3.	Prohibit architectures supporting the Linux kernel from
	speculating stores.

4.	Document what ACCESS_ONCE() does along with a number of situations
	requiring its use.

Changes from v3:

o	Fix typos noted by Peter Zijlstra.

o	Added the documentation about ACCESS_ONCE(), which expands on
	http://thread.gmane.org/gmane.linux.kernel.mm/82891/focus=14696,
	ably summarized by Jon Corbet at http://lwn.net/Articles/508991/.

Changes from v2:

o	Update examples so that that load against which the subsequent
	store is to be ordered is part of the "if" condition.

o	Add an example showing how the compiler can remove "if"
	conditions and how to prevent it from doing so.

o	Add ACCESS_ONCE() to the compiler-barrier section.

o	Add a sentence noting that transitivity requires smp_mb().

Changes from v1:

o	Combined with Peter Zijlstra's speculative-store-prohibition patch.

o	Added more pitfalls to avoid when prohibiting speculative
	stores, along with how to avoid them.

o	Applied Josh Triplett's review comments.

							Thanx, Paul


 b/Documentation/memory-barriers.txt |  666 ++++++++++++++++++++++++++++--------
 1 file changed, 533 insertions(+), 133 deletions(-)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab3KUVbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 16:31:06 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:44405 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab3KUVbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 16:31:02 -0500
Date: Thu, 21 Nov 2013 13:30:55 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: [PATCH v2 RFC 0/3] Memory-barrier documentation updates
Message-ID: <20131121213055.GA6938@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112121-0928-0000-0000-000003A9F2D3
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

Changes from v1:

o	Combined with Peter Zijlstra's speculative-store-prohibition patch.

o	Added more pitfalls to avoid when prohibiting speculative
	stores, along with how to avoid them.

o	Applied Josh Triplett's review comments.

							Thanx, Paul

 b/Documentation/memory-barriers.txt |  360 ++++++++++++++++++++++++++----------
 1 file changed, 266 insertions(+), 94 deletions(-)


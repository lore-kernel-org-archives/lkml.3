Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab3A0AT1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 19:19:27 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:58462 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab3A0ATX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 19:19:23 -0500
Date: Sat, 26 Jan 2013 16:18:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/2] Callback tagging for 3.9
Message-ID: <20130127001804.GA4122@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012700-7408-0000-0000-00000C4018CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains callback-tagging patches.  These were sent earlier
in the idle/no-CBs series, but have been isolated as the more trustworthy
part of that series.

1.	Tag callback lists with the grace-period number that they are
	waiting for.  This change enables a number of optimizations
	for RCU_FAST_NO_HZ, and though it add a bit of code, it greatly
	simplifies RCU's callback handling.
2.	Trace callback acceleration (which is when RCU notices that a
	group of callbacks doesn't actually need to wait as long as it
	previously thought).

							Thanx, Paul


 b/include/trace/events/rcu.h |    6 -
 b/kernel/rcutree.c           |  201 +++++++++++++++++++++++++++++++++++++------
 b/kernel/rcutree.h           |    2 
 3 files changed, 179 insertions(+), 30 deletions(-)


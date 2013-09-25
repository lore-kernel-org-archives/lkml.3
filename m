Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355Ab3IYBfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:35:00 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:57057 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756986Ab3IYBe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:34:58 -0400
Date: Tue, 24 Sep 2013 18:34:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/13] Sparse-related updates for 3.13
Message-ID: <20130925013451.GA31260@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-1344-0000-0000-000001EB038B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series features updates to allow sparse to do a better job of
statically analyzing RCU usage:

1.	Apply ACCESS_ONCE() to rcu_assign_pointer()'s target to prevent
	comiler mischief.  Also require that the source pointer be from
	the kernel address space.  Sometimes it can be from the RCU address
	space, which necessitates the remaining patches in this series.
	Which, it must be admitted, apply to a very small fraction of
	the rcu_assign_pointer() invocations in the kernel.  This commit
	courtesy of Josh Triplett.

2-13.	Apply rcu_access_pointer() to avoid a number of false positives.

							Thanx, Paul


 b/drivers/net/bonding/bond_alb.c  |    3 ++-
 b/drivers/net/bonding/bond_main.c |    8 +++++---
 b/include/linux/rcupdate.h        |   12 +++++++++++-
 b/kernel/notifier.c               |    2 +-
 b/net/bridge/br_mdb.c             |    2 +-
 b/net/bridge/br_multicast.c       |    4 ++--
 b/net/decnet/dn_route.c           |    5 +++--
 b/net/ipv4/ip_sockglue.c          |    2 +-
 b/net/ipv6/ip6_gre.c              |    2 +-
 b/net/ipv6/ip6_tunnel.c           |    2 +-
 b/net/ipv6/sit.c                  |    2 +-
 b/net/mac80211/sta_info.c         |    4 ++--
 b/net/wireless/scan.c             |   14 +++++++-------
 13 files changed, 38 insertions(+), 24 deletions(-)


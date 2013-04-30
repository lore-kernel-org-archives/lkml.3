Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267Ab3D3CxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 22:53:13 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:47742 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760578Ab3D3CxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 22:53:06 -0400
From: Simon Horman <horms@verge.net.au>
To: Eric Dumazet <eric.dumazet@gmail.com>, Julian Anastasov <ja@ssi.bg>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Simon Horman <horms@verge.net.au>
Subject: [PATCH v2 0/2] sched: Add cond_resched_rcu_lock() helper
Date: Tue, 30 Apr 2013 11:52:56 +0900
Message-Id: <1367290378-29224-1-git-send-email-horms@verge.net.au>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a helper that for use in loops which read data protected by RCU and
may have a large number of iterations.  Such an example is dumping the list
of connections known to IPVS: ip_vs_conn_array() and ip_vs_conn_seq_next().

This series also updates the two ip_vs functions mentioned above
to use the helper.

Changes since v1 noted in the changelog of each patch.

Simon Horman (2):
  sched: Add cond_resched_rcu_lock() helper
  ipvs: Use cond_resched_rcu_lock() helper when dumping connections

 include/linux/sched.h           | 11 +++++++++++
 net/netfilter/ipvs/ip_vs_conn.c |  6 ++----
 2 files changed, 13 insertions(+), 4 deletions(-)

-- 
1.8.2.1


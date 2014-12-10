Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaLJIq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:46:27 -0500
Received: from mail1.windriver.com ([147.11.146.13]:59473 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaLJIq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:46:26 -0500
From: Ying Xue <ying.xue@windriver.com>
To: <paulmck@linux.vnet.ibm.com>
CC: <davem@davemloft.net>, <eric.dumazet@gmail.com>, <jon.maloy@ericsson.com>,
        <erik.hugne@ericsson.com>, <netdev@vger.kernel.org>,
        <kbuild-all@01.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next RESEND 0/2] fix rculist sparse errors
Date: Wed, 10 Dec 2014 16:46:05 +0800
Message-ID: <1418201167-9591-1-git-send-email-ying.xue@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When hlist_for_each_entry_continue_rcu_bh() gets "next" pointer of
hlist_node structure through rcu_dereference_bh(), sparse warning
appears as the "next" pointer is not annotated as __rcu. So if
the "next" pointer is accessed with hlist_next_rcu() macro, the
__rcu annotation will be added to the pointer. As a consequence,
sparse warning is eliminated too.

The similar errors also appear in hlist_for_each_entry_continue_rcu()
and hlist_for_each_entry_from_rcu().

In this version, CC more people like Paul E. McKenney and lkml mail
list.

Ying Xue (2):
  tipc: fix RCU sparse error
  ipv6: fix sparse warning

 include/linux/rculist.h |   20 ++++++++++----------
 net/tipc/name_table.c   |    6 +++---
 2 files changed, 13 insertions(+), 13 deletions(-)

-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbaHVN0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:26:15 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:64603 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbaHVN0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:26:14 -0400
Date: Fri, 22 Aug 2014 16:26:05 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] kernel: events: core: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Message-ID: <20140822132605.GA20130@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of "rcu_assign_pointer()" is NULLing out the pointer.
According to RCU_INIT_POINTER()'s block comment:
"1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
it is better to use it instead of rcu_assign_pointer() because it has a
smaller overhead.

The following Coccinelle semantic patch was used:
@@
@@

- rcu_assign_pointer
+ RCU_INIT_POINTER
  (..., NULL)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0d735be..4b84dd5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5744,7 +5744,7 @@ static void swevent_hlist_release(struct swevent_htable *swhash)
 	if (!hlist)
 		return;
 
-	rcu_assign_pointer(swhash->swevent_hlist, NULL);
+	RCU_INIT_POINTER(swhash->swevent_hlist, NULL);
 	kfree_rcu(hlist, rcu_head);
 }
 
-- 
1.9.1


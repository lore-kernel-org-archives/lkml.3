Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbaHVOPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:15:46 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:42037 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088AbaHVOPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:15:45 -0400
Date: Fri, 22 Aug 2014 17:15:36 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] kernel: events: callchain: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Message-ID: <20140822141536.GA32051@ada>
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
 kernel/events/callchain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 97b67df..f2a88de 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -52,7 +52,7 @@ static void release_callchain_buffers(void)
 	struct callchain_cpus_entries *entries;
 
 	entries = callchain_cpus_entries;
-	rcu_assign_pointer(callchain_cpus_entries, NULL);
+	RCU_INIT_POINTER(callchain_cpus_entries, NULL);
 	call_rcu(&entries->rcu_head, release_callchain_buffers_rcu);
 }
 
-- 
1.9.1


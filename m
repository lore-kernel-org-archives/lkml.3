Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284AbaCWStQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 14:49:16 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:56635 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaCWStP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 14:49:15 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/events: Use RCU_INIT_POINTER(x, NULL) in callchain.c
Date: Mon, 24 Mar 2014 00:18:14 +0530
Message-Id: <1395600494-10091-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure       
is carried out before storing a pointer to that structure. 
And in the case of the NULL pointer, there is no structure to initialize. 
So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 kernel/events/callchain.c |    2 +-
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
1.7.9.5


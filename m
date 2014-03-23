Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaCWTKL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:10:11 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:57209 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaCWTKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:10:07 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: mathieu.desnoyers@efficios.com, rostedt@goodmis.org,
        keun-o.park@windriver.com, linux-kernel@vger.kernel.org
Subject: [PATCH] kernel: Use RCU_INIT_POINTER(x, NULL) in tracepoint.c
Date: Mon, 24 Mar 2014 00:39:08 +0530
Message-Id: <1395601748-12313-1-git-send-email-monamagarwal123@gmail.com>
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
 kernel/tracepoint.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 031cc56..72dfa96 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -291,7 +291,7 @@ static void disable_tracepoint(struct tracepoint *elem)
 
 	if (static_key_enabled(&elem->key))
 		static_key_slow_dec(&elem->key);
-	rcu_assign_pointer(elem->funcs, NULL);
+	RCU_INIT_POINTER(elem->funcs, NULL);
 }
 
 /**
-- 
1.7.9.5


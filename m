Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab3JCA4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 20:56:14 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:43028 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab3JCA4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 20:56:13 -0400
From: Nick Swenson <nks@daterainc.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        Kent Overstreet <kmo@daterainc.com>, Nick Swenson <nks@daterainc.com>
Subject: [PATCH] percpu_ida: Removing unused arguement from alloc_local_tag
Date: Wed,  2 Oct 2013 17:55:45 -0700
Message-Id: <1380761745-8605-1-git-send-email-nks@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing unused struct percpu_ida *pool from arguemnts of
alloc_local_tag, changed it's one use in idr.c

Signed-Off-By: Nick Swenson <nks@daterainc.com>
---
 lib/idr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 26495e1..86e8f73 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -1254,8 +1254,7 @@ static inline void alloc_global_tags(struct percpu_ida *pool,
 		  min(pool->nr_free, IDA_PCPU_BATCH_MOVE));
 }
 
-static inline unsigned alloc_local_tag(struct percpu_ida *pool,
-				       struct percpu_ida_cpu *tags)
+static inline unsigned alloc_local_tag(struct percpu_ida_cpu *tags)
 {
 	int tag = -ENOSPC;
 
@@ -1291,7 +1290,7 @@ int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp)
 	tags = this_cpu_ptr(pool->tag_cpu);
 
 	/* Fastpath */
-	tag = alloc_local_tag(pool, tags);
+	tag = alloc_local_tag(tags);
 	if (likely(tag >= 0)) {
 		local_irq_restore(flags);
 		return tag;
-- 
1.8.4.rc3


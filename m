Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935688Ab3DJASU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:18:20 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46928 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765442Ab3DJAST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:18:19 -0400
X-AuditID: 9c93016f-b7b3fae0000004d3-f7-5164afc94795
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 1/3] tracing: Get rid of unneeded key calculation in ftrace_hash_move()
Date: Wed, 10 Apr 2013 09:18:11 +0900
Message-Id: <1365553093-10180-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's not used anywhere in the function.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/ftrace.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 78f4398cb608..03953fbd1b2a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1312,7 +1312,6 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
 	struct hlist_head *hhd;
 	struct ftrace_hash *old_hash;
 	struct ftrace_hash *new_hash;
-	unsigned long key;
 	int size = src->count;
 	int bits = 0;
 	int ret;
@@ -1355,10 +1354,6 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
 	for (i = 0; i < size; i++) {
 		hhd = &src->buckets[i];
 		hlist_for_each_entry_safe(entry, tp, tn, hhd, hlist) {
-			if (bits > 0)
-				key = hash_long(entry->ip, bits);
-			else
-				key = 0;
 			remove_hash_entry(src, entry);
 			__add_hash_entry(new_hash, entry);
 		}
-- 
1.7.11.7


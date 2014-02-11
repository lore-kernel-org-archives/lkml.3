Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaBKGiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 01:38:18 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:47368 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaBKGiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 01:38:16 -0500
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH TIRIVAL] sched/core: Use TASK_USER_PRIO macro in set_load_weight()
Date: Tue, 11 Feb 2014 12:08:06 +0530
Message-Id: <1392100686-9020-1-git-send-email-kamalesh@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021106-4790-0000-0000-00000CA9A9EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use TASK_USER_PRIO macro, instead of handcoding priority to
set load weight.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 104c8164e04f..5f1c24bc453a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -742,7 +742,7 @@ int tg_nop(struct task_group *tg, void *data)
 
 static void set_load_weight(struct task_struct *p)
 {
-	int prio = p->static_prio - MAX_RT_PRIO;
+	int prio = TASK_USER_PRIO(p);
 	struct load_weight *load = &p->se.load;
 
 	/*
-- 
1.8.4.474.g128a96c


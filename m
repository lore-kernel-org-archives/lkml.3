Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab3L0LlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 06:41:25 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:36374 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab3L0LlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 06:41:22 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 1/5] sched, rt: move .switched_from out of the scope of CONFIG_SMP
Date: Fri, 27 Dec 2013 19:41:00 +0800
Message-Id: <1388144464-28458-2-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1388144464-28458-1-git-send-email-zwu.kernel@gmail.com>
References: <1388144464-28458-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122711-1542-0000-0000-000004A9649D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

.switched_from shouldn't be initialized in the scope of CONFIG_SMP,
so this patch is trying to move it out.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 kernel/sched/rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 1c40655..f34d41b 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2002,9 +2002,9 @@ const struct sched_class rt_sched_class = {
 	.pre_schedule		= pre_schedule_rt,
 	.post_schedule		= post_schedule_rt,
 	.task_woken		= task_woken_rt,
-	.switched_from		= switched_from_rt,
 #endif
 
+	.switched_from		= switched_from_rt,
 	.set_curr_task          = set_curr_task_rt,
 	.task_tick		= task_tick_rt,
 
-- 
1.7.6.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaEUQzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 12:55:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbaEUQze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 12:55:34 -0400
From: Masatake YAMATO <yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: yamato@redhat.com
Subject: [PATCH] wait: swap EXIT_ZOMBIE(Z) and EXIT_DEAD(X) chars in TASK_STATE_TO_CHAR_STR
Date: Thu, 22 May 2014 01:55:26 +0900
Message-Id: <1400691326-10783-1-git-send-email-yamato@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ad86622b478eaafdc25b74237df82b10fce6326d the order of
task state definitions were changed: EXIT_DEAD and EXIT_ZOMBIE
were swapped. Though the charterers for the states in
TASK_STATE_TO_CHAR_STR string were not updated. This patch
synchronizes the string to the order of definitions.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 include/linux/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 25f54c7..21fbdae 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -220,7 +220,7 @@ print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq);
 #define TASK_PARKED		512
 #define TASK_STATE_MAX		1024
 
-#define TASK_STATE_TO_CHAR_STR "RSDTtZXxKWP"
+#define TASK_STATE_TO_CHAR_STR "RSDTtXZxKWP"
 
 extern char ___assert_task_state[1 - 2*!!(
 		sizeof(TASK_STATE_TO_CHAR_STR)-1 != ilog2(TASK_STATE_MAX)+1)];
-- 
1.9.0


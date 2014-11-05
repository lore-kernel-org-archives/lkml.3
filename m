Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbaKEPtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:49:15 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:33909 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbaKEPtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:49:11 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH v3 6/7] sched/deadline: Remove unnecessary definitions in cpudeadline.h
Date: Wed,  5 Nov 2014 23:48:25 +0800
Message-Id: <1415202506-7800-6-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1415202506-7800-1-git-send-email-pang.xunlei@linaro.org>
References: <1415202506-7800-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, cpudl_set() and cpudl_init() can never be used without
CONFIG_SMP.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 kernel/sched/cpudeadline.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/sched/cpudeadline.h b/kernel/sched/cpudeadline.h
index 0c9636e..dfdf594 100644
--- a/kernel/sched/cpudeadline.h
+++ b/kernel/sched/cpudeadline.h
@@ -25,9 +25,6 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid);
 int cpudl_init(struct cpudl *cp);
 void cpudl_cleanup(struct cpudl *cp);
-#else
-#define cpudl_set(cp, cpu, dl) do { } while (0)
-#define cpudl_init() do { } while (0)
 #endif /* CONFIG_SMP */
 
 #endif /* _LINUX_CPUDL_H */
-- 
2.1.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbaKDLQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:16:04 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:46867 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbaKDLPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:15:45 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH v2 6/6] sched/dl: Remove unnecessary definitions in cpudeadline.h
Date: Tue,  4 Nov 2014 19:13:05 +0800
Message-Id: <1415099585-31174-6-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415099585-31174-1-git-send-email-pang.xunlei@linaro.org>
References: <1415099585-31174-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, cpudl_set() and cpudl_init() can never be used without
CONFIG_SMP.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 kernel/sched/cpudeadline.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/sched/cpudeadline.h b/kernel/sched/cpudeadline.h
index d79e4d8..7096e5a 100644
--- a/kernel/sched/cpudeadline.h
+++ b/kernel/sched/cpudeadline.h
@@ -34,9 +34,6 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int set_flags);
 int cpudl_init(struct cpudl *cp);
 void cpudl_cleanup(struct cpudl *cp);
-#else
-#define cpudl_set(cp, cpu, dl) do { } while (0)
-#define cpudl_init() do { } while (0)
 #endif /* CONFIG_SMP */
 
 #endif /* _LINUX_CPUDL_H */
-- 
1.7.9.5


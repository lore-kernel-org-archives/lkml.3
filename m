Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaKFHwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 02:52:54 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:64086 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaKFHww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 02:52:52 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH v4 1/7] sched/cpupri: Remove unnecessary definitions in cpupri.h
Date: Thu,  6 Nov 2014 15:52:01 +0800
Message-Id: <1415260327-30465-1-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, cpupri_set() and cpupri_init() can never be used without
CONFIG_SMP.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 kernel/sched/cpupri.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/sched/cpupri.h b/kernel/sched/cpupri.h
index 6b03334..63cbb9c 100644
--- a/kernel/sched/cpupri.h
+++ b/kernel/sched/cpupri.h
@@ -26,9 +26,6 @@ int  cpupri_find(struct cpupri *cp,
 void cpupri_set(struct cpupri *cp, int cpu, int pri);
 int cpupri_init(struct cpupri *cp);
 void cpupri_cleanup(struct cpupri *cp);
-#else
-#define cpupri_set(cp, cpu, pri) do { } while (0)
-#define cpupri_init() do { } while (0)
 #endif
 
 #endif /* _LINUX_CPUPRI_H */
-- 
1.7.9.5


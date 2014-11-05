Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbaKEPsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:48:52 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:39713 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbaKEPsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:48:50 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH v3 2/7] sched/cpupri: Remove unnecessary definitions in cpupri.h
Date: Wed,  5 Nov 2014 23:48:21 +0800
Message-Id: <1415202506-7800-2-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1415202506-7800-1-git-send-email-pang.xunlei@linaro.org>
References: <1415202506-7800-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, cpupri_set() and cpupri_init() can never be used without
CONFIG_SMP.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 kernel/sched/cpupri.h | 3 ---
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
2.1.0


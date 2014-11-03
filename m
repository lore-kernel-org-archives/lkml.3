Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390AbaKCKb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:31:27 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:39671 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaKCKbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:31:19 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH 2/3] sched/cpupri: Remove unnecessary definitions in cpupri.h
Date: Mon,  3 Nov 2014 18:30:19 +0800
Message-Id: <1415010620-6176-2-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415010620-6176-1-git-send-email-pang.xunlei@linaro.org>
References: <1415010620-6176-1-git-send-email-pang.xunlei@linaro.org>
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


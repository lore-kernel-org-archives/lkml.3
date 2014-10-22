Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583AbaJVI1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:27:05 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:42920 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932158AbaJVI0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:26:40 -0400
X-IronPort-AV: E=Sophos;i="5.04,767,1406563200"; 
   d="scan'208";a="37711571"
From: chai wen <chaiw.fnst@cn.fujitsu.com>
To: <will.deacon@arm.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <yuichi.kusakabe@jp.fujitsu.com>,
        chai wen <chaiw.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] ARM: perf: armv7: wrap unsupported arch init functions via micro
Date: Wed, 22 Oct 2014 16:21:47 +0800
Message-ID: <1413966107-11881-2-git-send-email-chaiw.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1413966107-11881-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
References: <1413966107-11881-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.161]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
---
 arch/arm/kernel/perf_event_v7.c |   52 +++++++++-----------------------------
 1 files changed, 13 insertions(+), 39 deletions(-)

diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
index f66a9b8..6c088e8 100644
--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -1459,43 +1459,17 @@ static int krait_pmu_init(struct arm_pmu *cpu_pmu)
 	return 0;
 }
 #else
-static inline int armv7_a8_pmu_init(struct arm_pmu *cpu_pmu)
-{
-	return -ENODEV;
-}
-
-static inline int armv7_a9_pmu_init(struct arm_pmu *cpu_pmu)
-{
-	return -ENODEV;
-}
-
-static inline int armv7_a5_pmu_init(struct arm_pmu *cpu_pmu)
-{
-	return -ENODEV;
-}
-
-static inline int armv7_a15_pmu_init(struct arm_pmu *cpu_pmu)
-{
-	return -ENODEV;
-}
-
-static inline int armv7_a7_pmu_init(struct arm_pmu *cpu_pmu)
-{
-	return -ENODEV;
-}
-
-static inline int armv7_a12_pmu_init(struct arm_pmu *cpu_pmu)
-{
-	return -ENODEV;
-}
-
-static inline int armv7_a17_pmu_init(struct arm_pmu *cpu_pmu)
-{
-	return -ENODEV;
-}
-
-static inline int krait_pmu_init(struct arm_pmu *cpu_pmu)
-{
-	return -ENODEV;
-}
+#define WRAP_UNSUPPORTED_INIT(__FUNC)                           \
+static inline int __FUNC(struct arm_pmu *cpu_pmu)               \
+{                                                               \
+        return -ENODEV;                                         \
+}
+WRAP_UNSUPPORTED_INIT(armv7_a8_pmu_init);
+WRAP_UNSUPPORTED_INIT(armv7_a9_pmu_init);
+WRAP_UNSUPPORTED_INIT(armv7_a5_pmu_init);
+WRAP_UNSUPPORTED_INIT(armv7_a15_pmu_init);
+WRAP_UNSUPPORTED_INIT(armv7_a7_pmu_init);
+WRAP_UNSUPPORTED_INIT(armv7_a12_pmu_init);
+WRAP_UNSUPPORTED_INIT(armv7_a17_pmu_init);
+WRAP_UNSUPPORTED_INIT(krait_pmu_init);
 #endif	/* CONFIG_CPU_V7 */
-- 
1.7.1


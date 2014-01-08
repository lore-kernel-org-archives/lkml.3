Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805AbaAHXAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 18:00:20 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54822 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334AbaAHW7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:59:49 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/7] ARM: perf_event: Silence sparse warning
Date: Wed,  8 Jan 2014 14:59:38 -0800
Message-Id: <1389221984-10973-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1389221984-10973-1-git-send-email-sboyd@codeaurora.org>
References: <1389221984-10973-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/kernel/perf_event_cpu.c:274:25: warning: incorrect type in assignment (different modifiers)
arch/arm/kernel/perf_event_cpu.c:274:25: expected int ( *init_fn )( ... )
arch/arm/kernel/perf_event_cpu.c:274:25: got void const *const data

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/perf_event_cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index d85055cd24ba..20d553c9f5e2 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -254,7 +254,7 @@ static int probe_current_pmu(struct arm_pmu *pmu)
 static int cpu_pmu_device_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *of_id;
-	int (*init_fn)(struct arm_pmu *);
+	const int (*init_fn)(struct arm_pmu *);
 	struct device_node *node = pdev->dev.of_node;
 	struct arm_pmu *pmu;
 	int ret = -ENODEV;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaBGVDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 16:03:04 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:56749 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaBGVB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 16:01:27 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 2/7] ARM: perf_event: Assign pdev pointer earlier for CPU PMUs
Date: Fri,  7 Feb 2014 13:01:20 -0800
Message-Id: <1391806885-24210-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1391806885-24210-1-git-send-email-sboyd@codeaurora.org>
References: <1391806885-24210-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to inspect the of_node that the pdev is pointing to in
the Krait CPU specific PMU initialization function. Assign it
earlier so that we don't crash with a NULL pointer dereference.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/perf_event_cpu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index 6efd8aab15df..68d02ca0ca1b 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -311,6 +311,9 @@ static int cpu_pmu_device_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	cpu_pmu = pmu;
+	cpu_pmu->plat_device = pdev;
+
 	if (node && (of_id = of_match_node(cpu_pmu_of_device_ids, pdev->dev.of_node))) {
 		init_fn = of_id->data;
 		ret = init_fn(pmu);
@@ -323,8 +326,6 @@ static int cpu_pmu_device_probe(struct platform_device *pdev)
 		goto out_free;
 	}
 
-	cpu_pmu = pmu;
-	cpu_pmu->plat_device = pdev;
 	cpu_pmu_init(cpu_pmu);
 	ret = armpmu_register(cpu_pmu, PERF_TYPE_RAW);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


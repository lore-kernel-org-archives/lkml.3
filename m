Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbaEEJ2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:28:00 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:49524 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954AbaEEJ1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:27:52 -0400
From: Chander Kashyap <chander.kashyap@linaro.org>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: lorenzo.pieralisi@arm.com, daniel.lezcano@linaro.org, rjw@rjwysocki.net,
        kgene.kim@samsung.com, Chander Kashyap <chander.kashyap@linaro.org>,
        Chander Kashyap <k.chander@samsung.com>
Subject: [Patch v4 4/5] exynos: cpuidle: do not allow cpuidle registration for Exynos5420
Date: Mon,  5 May 2014 14:57:19 +0530
Message-Id: <1399282040-8995-5-git-send-email-chander.kashyap@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399282040-8995-1-git-send-email-chander.kashyap@linaro.org>
References: <1399278444-8312-3-git-send-email-chander.kashyap@linaro.org>
 <1399282040-8995-1-git-send-email-chander.kashyap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos5420 is big.Little Soc. It uses cpuidle-big-litle generic cpuidle driver.
Hence do not allow exynos cpuidle driver registration for Exynos5420.

Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
Signed-off-by: Chander Kashyap <k.chander@samsung.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/mach-exynos/cpuidle.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-exynos/cpuidle.c b/arch/arm/mach-exynos/cpuidle.c
index c57cae0..242f75d 100644
--- a/arch/arm/mach-exynos/cpuidle.c
+++ b/arch/arm/mach-exynos/cpuidle.c
@@ -219,6 +219,9 @@ static int exynos_cpuidle_probe(struct platform_device *pdev)
 	int cpu_id, ret;
 	struct cpuidle_device *device;
 
+	if (soc_is_exynos5420())
+		return -ENODEV;
+
 	if (soc_is_exynos5250())
 		exynos5_core_down_clk();
 
-- 
1.7.9.5


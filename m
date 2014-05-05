Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbaEEI1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:27:53 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:35822 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054AbaEEI1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:27:47 -0400
From: Chander Kashyap <chander.kashyap@linaro.org>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: lorenzo.pieralisi@arm.com, daniel.lezcano@linaro.org, rjw@rjwysocki.net,
        kgene.kim@samsung.com, Chander Kashyap <chander.kashyap@linaro.org>,
        Chander Kashyap <k.chander@samsung.com>
Subject: [Patch v3 2/5] cpuidle: config: Add ARCH_EXYNOS entry to select cpuidle-big-little driver
Date: Mon,  5 May 2014 13:57:21 +0530
Message-Id: <1399278444-8312-3-git-send-email-chander.kashyap@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399278444-8312-1-git-send-email-chander.kashyap@linaro.org>
References: <1398245154-18771-1-git-send-email-chander.kashyap@linaro.org>
 <1399278444-8312-1-git-send-email-chander.kashyap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos5420 is a big-little SoC from Samsung. It has 4 A15 and 4 A7 cores.
In order to use generic cpuidle-big-little driver, this patch adds Exynos5420
specific check to initialize generic cpuidle driver.

Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
Signed-off-by: Chander Kashyap <k.chander@samsung.com>
---
Changes in v3: None
Changes in v2:
	1. Changed config macro from SOC_EXYNOS5420 to SOC_EXYNOS5420
 drivers/cpuidle/Kconfig.arm |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/Kconfig.arm b/drivers/cpuidle/Kconfig.arm
index 97ccc31..d9596e7 100644
--- a/drivers/cpuidle/Kconfig.arm
+++ b/drivers/cpuidle/Kconfig.arm
@@ -4,7 +4,7 @@
 
 config ARM_BIG_LITTLE_CPUIDLE
 	bool "Support for ARM big.LITTLE processors"
-	depends on ARCH_VEXPRESS_TC2_PM
+	depends on ARCH_VEXPRESS_TC2_PM || ARCH_EXYNOS
 	select ARM_CPU_SUSPEND
 	select CPU_IDLE_MULTIPLE_DRIVERS
 	help
-- 
1.7.9.5


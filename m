Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbaDXJcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:32:22 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:63632 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbaDXJbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 05:31:55 -0400
From: Leela Krishna Amudala <leela.krishna@linaro.org>
To: linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: daniel.lezcano@linaro.org, nicolas.pitre@linaro.org, kgene.kim@samsung.com,
        amit.kucheria@linaro.org
Subject: [PATCH 2/2] ARM: EXYNOS: use generic exynos cpu power control functions
Date: Thu, 24 Apr 2014 15:01:59 +0530
Message-Id: <1398331919-28321-3-git-send-email-leela.krishna@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398331919-28321-1-git-send-email-leela.krishna@linaro.org>
References: <1398331919-28321-1-git-send-email-leela.krishna@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use generic exynos cpu power control functions to power up/down
and to know the status of the cpu.

Signed-off-by: Leela Krishna Amudala <leela.krishna@linaro.org>
---
 arch/arm/mach-exynos/platsmp.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 03e5e9f..e3d005b 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -107,15 +107,12 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	 */
 	write_pen_release(phys_cpu);
 
-	if (!(__raw_readl(S5P_ARM_CORE1_STATUS) & S5P_CORE_LOCAL_PWR_EN)) {
-		__raw_writel(S5P_CORE_LOCAL_PWR_EN,
-			     S5P_ARM_CORE1_CONFIGURATION);
-
+	if (!exynos_cpu_power_state(cpu)) {
+		exynos_cpu_powerup(cpu);
 		timeout = 10;
 
 		/* wait max 10 ms until cpu1 is on */
-		while ((__raw_readl(S5P_ARM_CORE1_STATUS)
-			& S5P_CORE_LOCAL_PWR_EN) != S5P_CORE_LOCAL_PWR_EN) {
+		while (exynos_cpu_power_state(cpu) != S5P_CORE_LOCAL_PWR_EN) {
 			if (timeout-- == 0)
 				break;
 
-- 
1.7.9.5


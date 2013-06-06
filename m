Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab3FFImj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 04:42:39 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34243 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504Ab3FFImg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 04:42:36 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: mturquette@linaro.org, kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH] clk: exynos5250: Add CLK_IGNORE_UNUSED flag for pmu clock
Date: Thu,  6 Jun 2013 13:58:18 +0530
Message-Id: <1370507298-9230-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently 'pmu' clock is not handled by any of the drivers.
Also before the introduction of CCF, this clock was not defined,
hence was left enabled always.

When this clock is disabled, software reset register becomes
inaccessible and system reboot doesn't work.

Upon restoring the default behaviour, system reboot starts working.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/clk/samsung/clk-exynos5250.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
index 5c97e75..3853da9 100644
--- a/drivers/clk/samsung/clk-exynos5250.c
+++ b/drivers/clk/samsung/clk-exynos5250.c
@@ -378,7 +378,7 @@ struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
 	GATE(hsi2c3, "hsi2c3", "aclk66", GATE_IP_PERIC, 31, 0, 0),
 	GATE(chipid, "chipid", "aclk66", GATE_IP_PERIS, 0, 0, 0),
 	GATE(sysreg, "sysreg", "aclk66", GATE_IP_PERIS, 1, 0, 0),
-	GATE(pmu, "pmu", "aclk66", GATE_IP_PERIS, 2, 0, 0),
+	GATE(pmu, "pmu", "aclk66", GATE_IP_PERIS, 2, CLK_IGNORE_UNUSED, 0),
 	GATE(tzpc0, "tzpc0", "aclk66", GATE_IP_PERIS, 6, 0, 0),
 	GATE(tzpc1, "tzpc1", "aclk66", GATE_IP_PERIS, 7, 0, 0),
 	GATE(tzpc2, "tzpc2", "aclk66", GATE_IP_PERIS, 8, 0, 0),
-- 
1.7.9.5


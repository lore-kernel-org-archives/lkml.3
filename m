Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbaCKWlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:41:18 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:34890 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003AbaCKWlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:41:15 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        ezequiel.garcia@free-electrons.com, ivan.khoronzhuk@ti.com,
        linus.walleij@linaro.org, magnus.damm@gmail.com,
        matthias.bgg@gmail.com, soren.brinkmann@xilinx.com,
        sboyd@codeaurora.org
Subject: [PATCH 15/17] arm: zynq: Don't use arm_global_timer with cpufreq
Date: Tue, 11 Mar 2014 23:40:51 +0100
Message-Id: <1394577653-8615-15-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394577653-8615-1-git-send-email-daniel.lezcano@linaro.org>
References: <531F8FAC.2040902@linaro.org>
 <1394577653-8615-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Soren Brinkmann <soren.brinkmann@xilinx.com>

The timer frequency of the arm_global_timer depends on the CPU
frequency. With cpufreq altering that frequency the arm_global_timer
does not maintain a stable time base. Therefore don't enable that timer
in case cpufreq is enabled.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Michal Simek <michal.simek@xilinx.com>
---
 arch/arm/mach-zynq/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-zynq/Kconfig b/arch/arm/mach-zynq/Kconfig
index 6b04260..f84fab1 100644
--- a/arch/arm/mach-zynq/Kconfig
+++ b/arch/arm/mach-zynq/Kconfig
@@ -13,6 +13,6 @@ config ARCH_ZYNQ
 	select HAVE_SMP
 	select SPARSE_IRQ
 	select CADENCE_TTC_TIMER
-	select ARM_GLOBAL_TIMER
+	select ARM_GLOBAL_TIMER if !CPU_FREQ
 	help
 	  Support for Xilinx Zynq ARM Cortex A9 Platform
-- 
1.7.9.5


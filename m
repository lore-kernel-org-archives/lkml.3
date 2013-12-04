Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310Ab3LDTkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 14:40:53 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52111 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933112Ab3LDTjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 14:39:17 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/5] ARM: msm: Only build timer.c if required
Date: Wed,  4 Dec 2013 11:39:11 -0800
Message-Id: <1386185952-27259-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.19.gdaad3aa
In-Reply-To: <1386185952-27259-1-git-send-email-sboyd@codeaurora.org>
References: <1386185952-27259-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MSM timer is only used on MSM devices that don't have the
architected timers. Introduce a hidden Kconfig option for this
driver so that we don't build it on the platforms that don't need
it.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig  | 9 +++++++++
 arch/arm/mach-msm/Makefile | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 2586c28..47cd2df 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -16,6 +16,7 @@ config ARCH_MSM7X00A
 	select MACH_TROUT if !MACH_HALIBUT
 	select MSM_PROC_COMM
 	select MSM_SMD
+	select MSM_TIMER
 	select MSM_SMD_PKG3
 
 config ARCH_MSM7X30
@@ -27,6 +28,7 @@ config ARCH_MSM7X30
 	select MSM_GPIOMUX
 	select MSM_PROC_COMM
 	select MSM_SMD
+	select MSM_TIMER
 	select MSM_VIC
 
 config ARCH_QSD8X50
@@ -38,6 +40,7 @@ config ARCH_QSD8X50
 	select MSM_GPIOMUX
 	select MSM_PROC_COMM
 	select MSM_SMD
+	select MSM_TIMER
 	select MSM_VIC
 
 endchoice
@@ -49,6 +52,7 @@ config ARCH_MSM8X60
 	select GPIO_MSM_V2
 	select HAVE_SMP
 	select MSM_SCM if SMP
+	select MSM_TIMER
 
 config ARCH_MSM8960
 	bool "MSM8960"
@@ -57,6 +61,7 @@ config ARCH_MSM8960
 	select HAVE_SMP
 	select GPIO_MSM_V2
 	select MSM_SCM if SMP
+	select MSM_TIMER
 
 config ARCH_MSM_DT
 	def_bool y
@@ -134,4 +139,8 @@ config MSM_GPIOMUX
 
 config MSM_SCM
 	bool
+
+config MSM_TIMER
+	bool
+
 endif
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 6baae6e..8e307a10 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -1,4 +1,4 @@
-obj-y += timer.o
+obj-$(CONFIG_MSM_TIMER) += timer.o
 obj-$(CONFIG_MSM_PROC_COMM) += clock.o
 
 obj-$(CONFIG_MSM_VIC) += irq-vic.o
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


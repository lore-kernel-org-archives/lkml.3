Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab3L3VQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 16:16:52 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:40068 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259Ab3L3VPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 16:15:38 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH v2 5/7] ARM: msm: Only build timer.c if required
Date: Mon, 30 Dec 2013 13:15:31 -0800
Message-Id: <1388438133-431-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1388438133-431-1-git-send-email-sboyd@codeaurora.org>
References: <1388438133-431-1-git-send-email-sboyd@codeaurora.org>
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
index 702553b..ff69e1c 100644
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
@@ -50,6 +53,7 @@ config ARCH_MSM8X60
 	select GPIO_MSM_V2
 	select HAVE_SMP
 	select MSM_SCM if SMP
+	select MSM_TIMER
 
 config ARCH_MSM8960
 	bool "MSM8960"
@@ -59,6 +63,7 @@ config ARCH_MSM8960
 	select HAVE_SMP
 	select GPIO_MSM_V2
 	select MSM_SCM if SMP
+	select MSM_TIMER
 
 config ARCH_MSM8974
 	bool "MSM8974"
@@ -145,4 +150,8 @@ config MSM_GPIOMUX
 
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


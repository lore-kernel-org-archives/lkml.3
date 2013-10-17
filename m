Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762880Ab3JQVbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:31:35 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:32783 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762808Ab3JQVbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:31:32 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rohit Vaswani <rvaswani@codeaurora.org>
Subject: [PATCH 1/3] ARM: msm: Simplify ARCH_MSM_DT config
Date: Thu, 17 Oct 2013 14:31:27 -0700
Message-Id: <1382045489-21075-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.1.516.g1d25dd4
In-Reply-To: <1382045489-21075-1-git-send-email-sboyd@codeaurora.org>
References: <1382034310-31147-1-git-send-email-rvaswani@codeaurora.org>
 <1382045489-21075-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This doesn't need to be a def_bool y. Instead we can have every
DT supported platform select ARCH_MSM_DT and we achieve the same
thing with less chance of conflicts.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 5e5782d..702553b 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -44,6 +44,7 @@ endchoice
 
 config ARCH_MSM8X60
 	bool "MSM8X60"
+	select ARCH_MSM_DT
 	select ARM_GIC
 	select CPU_V7
 	select GPIO_MSM_V2
@@ -52,6 +53,7 @@ config ARCH_MSM8X60
 
 config ARCH_MSM8960
 	bool "MSM8960"
+	select ARCH_MSM_DT
 	select ARM_GIC
 	select CPU_V7
 	select HAVE_SMP
@@ -60,6 +62,7 @@ config ARCH_MSM8960
 
 config ARCH_MSM8974
 	bool "MSM8974"
+	select ARCH_MSM_DT
 	select ARM_GIC
 	select CPU_V7
 	select HAVE_ARM_ARCH_TIMER
@@ -68,8 +71,7 @@ config ARCH_MSM8974
 	select USE_OF
 
 config ARCH_MSM_DT
-	def_bool y
-	depends on (ARCH_MSM8X60 || ARCH_MSM8960 || ARCH_MSM8974)
+	bool
 	select SPARSE_IRQ
 	select USE_OF
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


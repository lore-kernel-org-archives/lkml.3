Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab3JRR4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:56:54 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54321 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab3JRR4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:56:51 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rohit Vaswani <rvaswani@codeaurora.org>
Subject: [PATCH v2 1/4] ARM: msm: Simplify ARCH_MSM_DT config
Date: Fri, 18 Oct 2013 10:56:43 -0700
Message-Id: <1382119006-22231-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.1.544.g2141c47
In-Reply-To: <1382119006-22231-1-git-send-email-sboyd@codeaurora.org>
References: <1382034310-31147-1-git-send-email-rvaswani@codeaurora.org>
 <1382119006-22231-1-git-send-email-sboyd@codeaurora.org>
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


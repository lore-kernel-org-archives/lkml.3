Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbbAUTWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 14:22:18 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49725 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbbAUTWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 14:22:11 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: qcom: Drop unnecessary selects from ARCH_QCOM
Date: Wed, 21 Jan 2015 11:22:09 -0800
Message-Id: <1421868129-20798-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.3.0.rc0.46.gbe498cc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to force gpiolib on everyone given that it isn't
required to actually boot the device and the multiplatform
Kconfig already selects ARCH_WANT_OPTIONAL_GPIOLIB. CLKSRC_OF is
already selected by CONFIG_ARCH_MULTIPLATFORM too, so we can drop
that here.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Based on qcom/soc at Kumar's tree

 arch/arm/mach-qcom/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mach-qcom/Kconfig b/arch/arm/mach-qcom/Kconfig
index 5e93814f458a..2256cd1e25d1 100644
--- a/arch/arm/mach-qcom/Kconfig
+++ b/arch/arm/mach-qcom/Kconfig
@@ -1,10 +1,8 @@
 menuconfig ARCH_QCOM
 	bool "Qualcomm Support" if ARCH_MULTI_V7
-	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_SUPPORTS_BIG_ENDIAN
 	select ARM_GIC
 	select ARM_AMBA
-	select CLKSRC_OF
 	select PINCTRL
 	select QCOM_SCM if SMP
 	help
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project


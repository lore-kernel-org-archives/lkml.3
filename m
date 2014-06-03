Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbaFCSaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:30:10 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58135 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991AbaFCSaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:30:05 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] unicore32: Remove ARCH_HAS_CPUFREQ config option
Date: Tue,  3 Jun 2014 11:30:03 -0700
Message-Id: <1401820203-21556-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config exists entirely to hide the cpufreq menu from the
kernel configuration unless a platform has selected it. Nothing
is actually built if this config is 'Y' and it just leads to more
patches that add a select under a platform Kconfig so that some
other CPUfreq option can be chosen. Let's remove the option so
that we can always enable CPUfreq drivers on unicore32 platforms.

Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/unicore32/Kconfig | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index aafad6fa1667..928237a7b9ca 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -51,9 +51,6 @@ config ARCH_HAS_ILOG2_U32
 config ARCH_HAS_ILOG2_U64
 	bool
 
-config ARCH_HAS_CPUFREQ
-	bool
-
 config GENERIC_HWEIGHT
 	def_bool y
 
@@ -87,7 +84,6 @@ config ARCH_PUV3
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
 	select ARCH_REQUIRE_GPIOLIB
-	select ARCH_HAS_CPUFREQ
 
 # CONFIGs for ARCH_PUV3
 
@@ -198,9 +194,7 @@ menu "Power management options"
 
 source "kernel/power/Kconfig"
 
-if ARCH_HAS_CPUFREQ
 source "drivers/cpufreq/Kconfig"
-endif
 
 config ARCH_SUSPEND_POSSIBLE
 	def_bool y if !ARCH_FPGA
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


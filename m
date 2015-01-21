Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbbAUTtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 14:49:00 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:51984 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbbAUTsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 14:48:20 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 2/2] ARM: qcom: Use secondary_startup_arm()
Date: Wed, 21 Jan 2015 11:48:18 -0800
Message-Id: <1421869698-27341-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.3.0.rc0.46.gbe498cc
In-Reply-To: <1421869698-27341-1-git-send-email-sboyd@codeaurora.org>
References: <1421869698-27341-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On qcom platforms we always enter the kernel in ARM mode,
regardless of the kernel being compiled for THUMB mode. Use
secondary_startup_arm() to properly switch the mode to what the
kernel expects if required.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-qcom/platsmp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-qcom/platsmp.c b/arch/arm/mach-qcom/platsmp.c
index a692bcb7e7f5..0f8b5147a78f 100644
--- a/arch/arm/mach-qcom/platsmp.c
+++ b/arch/arm/mach-qcom/platsmp.c
@@ -44,7 +44,7 @@
 #define APCS_SAW2_VCTL		0x14
 #define APCS_SAW2_2_VCTL	0x1c
 
-extern void secondary_startup(void);
+extern void secondary_startup_arm(void);
 
 static DEFINE_SPINLOCK(boot_lock);
 
@@ -337,7 +337,7 @@ static void __init qcom_smp_prepare_cpus(unsigned int max_cpus)
 		flags |= cold_boot_flags[map];
 	}
 
-	if (scm_set_boot_addr(virt_to_phys(secondary_startup), flags)) {
+	if (scm_set_boot_addr(virt_to_phys(secondary_startup_arm), flags)) {
 		for_each_present_cpu(cpu) {
 			if (cpu == smp_processor_id())
 				continue;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project


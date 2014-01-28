Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbaA1S0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 13:26:32 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44717 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbaA1S0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 13:26:31 -0500
From: Christopher Covington <cov@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Christopher Covington <cov@codeaurora.org>
Subject: [PATCH v2] ARM: hw_breakpoint: Add ARMv8 support
Date: Tue, 28 Jan 2014 13:26:23 -0500
Message-Id: <1390933583-1278-1-git-send-email-cov@codeaurora.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1390415365-17230-1-git-send-email-cov@codeaurora.org>
References: <1390415365-17230-1-git-send-email-cov@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the trivial support necessary to get hardware breakpoints
working for GDB on ARMv8 simulators running in AArch32 mode.

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---

 v2: modify debug_exception_updates_fsr

 arch/arm/include/asm/hw_breakpoint.h | 1 +
 arch/arm/kernel/hw_breakpoint.c      | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/hw_breakpoint.h b/arch/arm/include/asm/hw_breakpoint.h
index eef55ea..8e427c7 100644
--- a/arch/arm/include/asm/hw_breakpoint.h
+++ b/arch/arm/include/asm/hw_breakpoint.h
@@ -51,6 +51,7 @@ static inline void decode_ctrl_reg(u32 reg,
 #define ARM_DEBUG_ARCH_V7_ECP14	3
 #define ARM_DEBUG_ARCH_V7_MM	4
 #define ARM_DEBUG_ARCH_V7_1	5
+#define ARM_DEBUG_ARCH_V8	6
 
 /* Breakpoint */
 #define ARM_BREAKPOINT_EXECUTE	0
diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
index 3d44660..a711b27 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -167,7 +167,7 @@ static int debug_arch_supported(void)
 /* Can we determine the watchpoint access type from the fsr? */
 static int debug_exception_updates_fsr(void)
 {
-	return 0;
+	return get_debug_arch() == ARM_DEBUG_ARCH_V8;
 }
 
 /* Determine number of WRP registers available. */
@@ -257,6 +257,7 @@ static int enable_monitor_mode(void)
 		break;
 	case ARM_DEBUG_ARCH_V7_ECP14:
 	case ARM_DEBUG_ARCH_V7_1:
+	case ARM_DEBUG_ARCH_V8:
 		ARM_DBG_WRITE(c0, c2, 2, (dscr | ARM_DSCR_MDBGEN));
 		isb();
 		break;
-- 
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by the Linux Foundation.


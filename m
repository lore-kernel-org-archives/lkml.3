Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3JCXGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 19:06:33 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34117 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3JCXGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 19:06:31 -0400
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] ARM: debug: msm: Add DEBUG_LL support for ARCH_MSM8974
Date: Thu,  3 Oct 2013 16:05:56 -0700
Message-Id: <1380841557-2673-4-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1380841557-2673-1-git-send-email-rvaswani@codeaurora.org>
References: <1380841557-2673-1-git-send-email-rvaswani@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add debug uart support for MSM8974. This patch adds a Kconfig
entry and the base address for the debug uart.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 arch/arm/Kconfig.debug       | 9 +++++++++
 arch/arm/include/debug/msm.S | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index e18a6fc..959b2c7 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -357,6 +357,15 @@ choice
 		  Say Y here if you want the debug print routines to direct
 		  their output to the serial port on MSM 8960 devices.
 
+	config DEBUG_MSM8974_UART
+		bool "Kernel low-level debugging messages via MSM 8974 UART"
+		depends on ARCH_MSM8974
+		select MSM_HAS_DEBUG_UART_HS
+		select DEBUG_MSM_UART
+		help
+		  Say Y here if you want the debug print routines to direct
+		  their output to the serial port on MSM 8974 devices.
+
 	config DEBUG_MVEBU_UART
 		bool "Kernel low-level debugging messages via MVEBU UART (old bootloaders)"
 		depends on ARCH_MVEBU
diff --git a/arch/arm/include/debug/msm.S b/arch/arm/include/debug/msm.S
index 9166e1b..9d653d4 100644
--- a/arch/arm/include/debug/msm.S
+++ b/arch/arm/include/debug/msm.S
@@ -46,6 +46,11 @@
 #define MSM_DEBUG_UART_PHYS	0x16440000
 #endif
 
+#ifdef CONFIG_DEBUG_MSM8974_UART
+#define MSM_DEBUG_UART_BASE	0xFA71E000
+#define MSM_DEBUG_UART_PHYS	0xF991E000
+#endif
+
 	.macro	addruart, rp, rv, tmp
 #ifdef MSM_DEBUG_UART_PHYS
 	ldr	\rp, =MSM_DEBUG_UART_PHYS
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


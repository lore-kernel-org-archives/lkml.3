Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaDEAa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 20:30:57 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58300 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbaDEAaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 20:30:55 -0400
From: Laura Abbott <lauraa@codeaurora.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: Laura Abbott <lauraa@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arm64: Add missing Kconfig for CONFIG_STRICT_DEVMEM
Date: Fri,  4 Apr 2014 17:30:50 -0700
Message-Id: <1396657850-14252-1-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig for CONFIG_STRICT_DEVMEM is missing despite being
used in mmap.c. Add it.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 arch/arm64/Kconfig.debug | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index 835c559..4be4336 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -6,6 +6,20 @@ config FRAME_POINTER
 	bool
 	default y
 
+config STRICT_DEVMEM
+	bool "Filter access to /dev/mem"
+	depends on MMU
+        help
+	  If this option is disabled, you allow userspace (root) access to all
+	  of memory, including kernel and userspace memory. Accidental
+	  access to this is obviously disastrous, but specific access can
+	  be used by people debugging the kernel.
+
+	  If this option is switched on, the /dev/mem file only allows
+	  userspace access to memory mapped peripherals.
+
+	  If in doubt, say Y.
+
 config EARLY_PRINTK
 	bool "Early printk support"
 	default y
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


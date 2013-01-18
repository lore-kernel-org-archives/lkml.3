Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab3ARMfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:35:14 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:59332 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab3ARMfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:35:10 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v2 68/76] ARC: Fold boards sub-menu into platform/SoC menu
Date: Fri, 18 Jan 2013 17:55:22 +0530
Message-ID: <1358511930-7424-69-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is more natural and is now doable since the choice constructs are
gone.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/Kconfig              |   21 +++------------------
 arch/arc/plat-arcfpga/Kconfig |   14 ++++++++++----
 2 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 414e53d..21ecd2a 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -82,18 +82,11 @@ source "kernel/Kconfig.freezer"
 
 menu "ARC Architecture Configuration"
 
-menu "ARC Platform/SoC"
-
-config ARC_PLAT_FPGA_LEGACY
-	bool "\"Legacy\" ARC FPGA dev platform"
-	help
-	  Support for ARC development platforms, provided by Synopsys.
-	  These are based on FPGA or ISS. e.g.
-	  - ARCAngel4
-	  - ML509
-	  - MetaWare ISS
+menu "ARC Platform/SoC/Board"
 
+source "arch/arc/plat-arcfpga/Kconfig"
 #New platform adds here
+
 endmenu
 
 menu "ARC CPU Configuration"
@@ -343,12 +336,6 @@ config ARC_HAS_RTSC
 
 endmenu   # "ARC CPU Configuration"
 
-menu "Platform Board Configuration"
-
-source "arch/arc/plat-arcfpga/Kconfig"
-
-#New platform adds here
-
 config LINUX_LINK_BASE
 	hex "Linux Link Address"
 	default "0x80000000"
@@ -362,8 +349,6 @@ config LINUX_LINK_BASE
 	  Linux needs to be scooted a bit.
 	  If you don't know what the above means, leave this setting alone.
 
-endmenu # "Platform Board Configuration"
-
 config ARC_CURR_IN_REG
 	bool "Dedicate Register r25 for current_task pointer"
 	default y
diff --git a/arch/arc/plat-arcfpga/Kconfig b/arch/arc/plat-arcfpga/Kconfig
index 4b6c042..6001784 100644
--- a/arch/arc/plat-arcfpga/Kconfig
+++ b/arch/arc/plat-arcfpga/Kconfig
@@ -6,12 +6,20 @@
 # published by the Free Software Foundation.
 #
 
-if ARC_PLAT_FPGA_LEGACY
+menuconfig ARC_PLAT_FPGA_LEGACY
+	bool "\"Legacy\" ARC FPGA dev Boards"
+	help
+	  Support for ARC development boards, provided by Synopsys.
+	  These are based on FPGA or ISS. e.g.
+	  - ARCAngel4
+	  - ML509
+	  - MetaWare ISS
 
-menu "FPGA Board"
+if ARC_PLAT_FPGA_LEGACY
 
 config ARC_BOARD_ANGEL4
 	bool "ARC Angel4"
+	default y
 	help
 	  ARC Angel4 FPGA Ref Platform (Xilinx Virtex Based)
 
@@ -33,8 +41,6 @@ config ISS_SMP_EXTN
 	  -XTL (To enable CPU start/stop/set-PC for another CPU)
 	  It doesn't provide coherent Caches and/or Atomic Ops (LLOCK/SCOND)
 
-endmenu
-
 config ARC_SERIAL_BAUD
 	int "UART Baud rate"
 	default "115200"
-- 
1.7.4.1


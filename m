Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab3AXLNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:13:06 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:47413 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab3AXLMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:12:53 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 61/71] ARC: Fold boards sub-menu into platform/SoC menu
Date: Thu, 24 Jan 2013 16:36:22 +0530
Message-ID: <1359025589-22277-39-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
References: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is more natural and is now doable since the choice constructs are
gone.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arc/Kconfig              |   21 +++------------------
 arch/arc/plat-arcfpga/Kconfig |   14 ++++++++++----
 2 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 3fdd6a5..ac17368 100644
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
@@ -338,12 +331,6 @@ config ARC_HAS_RTSC
 
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
@@ -357,8 +344,6 @@ config LINUX_LINK_BASE
 	  Linux needs to be scooted a bit.
 	  If you don't know what the above means, leave this setting alone.
 
-endmenu # "Platform Board Configuration"
-
 config ARC_CURR_IN_REG
 	bool "Dedicate Register r25 for current_task pointer"
 	default y
diff --git a/arch/arc/plat-arcfpga/Kconfig b/arch/arc/plat-arcfpga/Kconfig
index ae2c017..3fecd6f 100644
--- a/arch/arc/plat-arcfpga/Kconfig
+++ b/arch/arc/plat-arcfpga/Kconfig
@@ -6,13 +6,21 @@
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
 	select ISS_SMP_EXTN if SMP
+	default y
 	help
 	  ARC Angel4 FPGA Ref Platform (Xilinx Virtex Based)
 
@@ -34,8 +42,6 @@ config ISS_SMP_EXTN
 	  -XTL (To enable CPU start/stop/set-PC for another CPU)
 	  It doesn't provide coherent Caches and/or Atomic Ops (LLOCK/SCOND)
 
-endmenu
-
 config ARC_SERIAL_BAUD
 	int "UART Baud rate"
 	default "115200"
-- 
1.7.4.1


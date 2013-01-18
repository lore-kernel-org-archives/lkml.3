Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab3ARMfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:35:07 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:55984 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab3ARMfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:35:03 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v2 67/76] ARC: [Review] Multi-platform image #1: Kconfig enablement
Date: Fri, 18 Jan 2013 17:55:21 +0530
Message-ID: <1358511930-7424-68-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This mini patchseries addresses the lack of multi-platform-image support
in ARC port.

Older build system only supported one platform(soc) to build at a time
and further only one board of that platform could be built. There was no
technical reason for that - we just didn't have the need.

So the first step towards multi-platform (and multi-board) builds it to
allow build system to do that.

So as applicable, <choice .. endchoice> => <menu .. endmenu>

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 arch/arc/Kconfig              |    6 ++----
 arch/arc/plat-arcfpga/Kconfig |    5 ++---
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index d73e69b..414e53d 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -82,9 +82,7 @@ source "kernel/Kconfig.freezer"
 
 menu "ARC Architecture Configuration"
 
-choice
-	prompt "ARC Platform"
-	default ARC_PLAT_FPGA_LEGACY
+menu "ARC Platform/SoC"
 
 config ARC_PLAT_FPGA_LEGACY
 	bool "\"Legacy\" ARC FPGA dev platform"
@@ -96,7 +94,7 @@ config ARC_PLAT_FPGA_LEGACY
 	  - MetaWare ISS
 
 #New platform adds here
-endchoice
+endmenu
 
 menu "ARC CPU Configuration"
 
diff --git a/arch/arc/plat-arcfpga/Kconfig b/arch/arc/plat-arcfpga/Kconfig
index 86b7377..4b6c042 100644
--- a/arch/arc/plat-arcfpga/Kconfig
+++ b/arch/arc/plat-arcfpga/Kconfig
@@ -8,8 +8,7 @@
 
 if ARC_PLAT_FPGA_LEGACY
 
-choice
-	prompt "FPGA Board"
+menu "FPGA Board"
 
 config ARC_BOARD_ANGEL4
 	bool "ARC Angel4"
@@ -34,7 +33,7 @@ config ISS_SMP_EXTN
 	  -XTL (To enable CPU start/stop/set-PC for another CPU)
 	  It doesn't provide coherent Caches and/or Atomic Ops (LLOCK/SCOND)
 
-endchoice
+endmenu
 
 config ARC_SERIAL_BAUD
 	int "UART Baud rate"
-- 
1.7.4.1


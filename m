Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbaDHI4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 04:56:13 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:56693 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750800AbaDHI4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:56:10 -0400
Message-ID: <1396947368.26620.2.camel@x220>
Subject: [PATCH] ARC: Remove ISS_SMP_EXTN entirely
From: Paul Bolle <pebolle@tiscali.nl>
To: Vineet Gupta <vgupta@synopsys.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 08 Apr 2014 10:56:08 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Apr 2014 08:56:08.0684 (UTC) FILETIME=[620C22C0:01CF5308]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol ARC_HAS_COH_RTSC was removed in v3.13. The Kconfig
entry for ISS_SMP_EXTN still had a select for that symbol. That select
was just removed in commit d345ea2892ae ("ARC: Remove
ARC_HAS_COH_RTSC").

But selecting ARC_HAS_COH_RTSC was the only thing ISS_SMP_EXTN ever
did. That means that since v3.13 setting ISS_SMP_EXTN was effectively a
nop anyhow. So ISS_SMP_EXTN can as well be removed entirely.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested wit "git grep" only.

 arch/arc/plat-arcfpga/Kconfig | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/arch/arc/plat-arcfpga/Kconfig b/arch/arc/plat-arcfpga/Kconfig
index 33058aa40e77..fde2a3fb604d 100644
--- a/arch/arc/plat-arcfpga/Kconfig
+++ b/arch/arc/plat-arcfpga/Kconfig
@@ -8,7 +8,6 @@
 
 menuconfig ARC_PLAT_FPGA_LEGACY
 	bool "\"Legacy\" ARC FPGA dev Boards"
-	select ISS_SMP_EXTN if SMP
 	help
 	  Support for ARC development boards, provided by Synopsys.
 	  These are based on FPGA or ISS. e.g.
@@ -29,18 +28,6 @@ config ARC_BOARD_ML509
 	help
 	  ARC ML509 FPGA Ref Platform (Xilinx Virtex-5 Based)
 
-config ISS_SMP_EXTN
-	bool "ARC SMP Extensions (ISS Models only)"
-	default n
-	depends on SMP
-	help
-	  SMP Extensions to ARC700, in a "simulation only" Model, supported in
-	  ARC ISS (Instruction Set Simulator).
-	  The SMP extensions include:
-	  -IDU (Interrupt Distribution Unit)
-	  -XTL (To enable CPU start/stop/set-PC for another CPU)
-	  It doesn't provide coherent Caches and/or Atomic Ops (LLOCK/SCOND)
-
 config ARC_SERIAL_BAUD
 	int "UART Baud rate"
 	default "115200"
-- 
1.9.0


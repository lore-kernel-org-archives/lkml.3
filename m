Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbaIWJjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 05:39:10 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:60234 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755229AbaIWJjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 05:39:06 -0400
Message-ID: <1411465144.20236.21.camel@x220>
Subject: [PATCH] ARC: [arcfpga] Get rid of ARC_BOARD_ANGEL4 and
 ARC_BOARD_ML509
From: Paul Bolle <pebolle@tiscali.nl>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 23 Sep 2014 11:39:04 +0200
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA230753C5DA1BE@IN01WEMBXA.internal.synopsys.com>
References: <1401874435.14072.17.camel@x220>
	 <C2D7FE5348E1B147BCA15975FBA230751A6B5C42@IN01WEMBXA.internal.synopsys.com>
	 <1410512426.31130.11.camel@x220>
	 <C2D7FE5348E1B147BCA15975FBA230753C5DA1BE@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Sep 2014 09:39:04.0653 (UTC) FILETIME=[36D7CFD0:01CFD712]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c00bfd974fb0 ("ARC: [arcfpga] Get rid of legacy BVCI latency unit
support") removed the Kconfig symbol ARC_HAS_BVCI_LAT_UNIT. And that
symbol's entry was the only place were the symbols ARC_BOARD_ANGEL4 and
ARC_BOARD_ML509 were used. So ARC_BOARD_ANGEL4 and ARC_BOARD_ML509 can
be removed too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Done on top of next-20140923. Tested by grepping the tree only.

There are still references in defconfig files. Should those be removed
too?

 arch/arc/plat-arcfpga/Kconfig | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/arc/plat-arcfpga/Kconfig b/arch/arc/plat-arcfpga/Kconfig
index 4965f9f4ffdc..217593a70751 100644
--- a/arch/arc/plat-arcfpga/Kconfig
+++ b/arch/arc/plat-arcfpga/Kconfig
@@ -18,17 +18,6 @@ menuconfig ARC_PLAT_FPGA_LEGACY
 
 if ARC_PLAT_FPGA_LEGACY
 
-config ARC_BOARD_ANGEL4
-	bool "ARC Angel4"
-	default y
-	help
-	  ARC Angel4 FPGA Ref Platform (Xilinx Virtex Based)
-
-config ARC_BOARD_ML509
-	bool "ML509"
-	help
-	  ARC ML509 FPGA Ref Platform (Xilinx Virtex-5 Based)
-
 config ISS_SMP_EXTN
 	bool "ARC SMP Extensions (ISS Models only)"
 	default n
-- 
1.9.3


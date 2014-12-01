Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaLADrI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 22:47:08 -0500
Received: from mail-bn1bbn0102.outbound.protection.outlook.com ([157.56.111.102]:49612
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752558AbaLADrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 22:47:03 -0500
X-WSS-ID: 0NFVX68-07-VX4-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <arnd@arndb.de>, <mark.rutland@arm.com>, <will.deacon@arm.com>,
        <marc.zyngier@arm.com>, <catalin.marinas@arm.com>
CC: <robherring2@gmail.com>, <liviu.dudau@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 1/2] arm64: amd-seattle: Fix dma-ranges property
Date: Sun, 30 Nov 2014 21:46:39 -0600
Message-ID: <1417405600-19232-2-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417405600-19232-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1417405600-19232-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(95666004)(20776003)(64706001)(105586002)(50986999)(102836001)(76176999)(104166001)(33646002)(106466001)(53416004)(107046002)(47776003)(36756003)(77096003)(21056001)(77156002)(62966003)(229853001)(46102003)(87936001)(101416001)(87286001)(89996001)(88136002)(31966008)(50226001)(97736003)(4396001)(44976005)(92726001)(19580395003)(120916001)(86362001)(92566001)(19580405001)(93916002)(86152002)(68736004)(99396003)(2201001)(84676001)(50466002)(48376002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB199;H:atltwp01.amd.com;FPR:;SPF:None;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB199;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB199;
X-Forefront-PRVS: 0412A98A59
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB199;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

AMD Seattle should support 40-bit DMA.

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---
 arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi b/arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi
index 0c8e7ae..f370f03 100644
--- a/arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi
+++ b/arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi
@@ -55,8 +55,12 @@
 		#size-cells = <2>;
 		ranges;
 
-		/* DDR range is 40-bit addressing */
-		dma-ranges = <0x80 0x0 0x80 0x0 0x7f 0xffffffff>;
+		/*
+		 * dma-ranges is 40-bit address space containing:
+		 * - GICv2m MSI register is at 0xe0080000
+		 * - DRAM range [0x8000000000 to 0xffffffffff]
+		 */
+		dma-ranges = <0x0 0x0 0x0 0x0 0x100 0x0>;
 
 		/include/ "amd-seattle-clks.dtsi"
 
@@ -159,7 +163,7 @@
 				<0x1000 0x0 0x0 0x4 &gic0 0x0 0x0 0x0 0x123 0x1>;
 
 			dma-coherent;
-			dma-ranges = <0x43000000 0x80 0x0 0x80 0x0 0x7f 0xffffffff>;
+			dma-ranges = <0x43000000 0x0 0x0 0x0 0x0 0x100 0x0>;
 			ranges =
 				/* I/O Memory (size=64K) */
 				<0x01000000 0x00 0x00000000 0x00 0xefff0000 0x00 0x00010000>,
-- 
1.9.3


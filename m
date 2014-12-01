Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaLADr2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 22:47:28 -0500
Received: from mail-bl2on0142.outbound.protection.outlook.com ([65.55.169.142]:53281
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752562AbaLADrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 22:47:06 -0500
X-WSS-ID: 0NFVX6D-07-VXB-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <arnd@arndb.de>, <mark.rutland@arm.com>, <will.deacon@arm.com>,
        <marc.zyngier@arm.com>, <catalin.marinas@arm.com>
CC: <robherring2@gmail.com>, <liviu.dudau@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 2/2] arm64: amd-seattle: Fix PCI bus range due to SMMU limitation
Date: Sun, 30 Nov 2014 21:46:40 -0600
Message-ID: <1417405600-19232-3-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417405600-19232-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1417405600-19232-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(50226001)(107046002)(120916001)(33646002)(4396001)(229853001)(31966008)(19580405001)(19580395003)(44976005)(99396003)(36756003)(68736004)(77096004)(97736003)(21056001)(77156002)(84676001)(62966003)(93916002)(86362001)(64706001)(76176999)(50466002)(50986999)(2201001)(86152002)(102836001)(101416001)(48376002)(92566001)(92726001)(106466001)(105586002)(46102003)(89996001)(104166001)(87286001)(95666004)(87936001)(88136002)(53416004)(47776003)(20776003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB204;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-Forefront-PRVS: 0412A98A59
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

Since PCIe is using SMMUv1 which only supports 15-bit stream ID,
only 7-bit PCI bus id is used to specify stream ID. Therefore,
we only limit the PCI bus range to 0x7f.

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---
 arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi b/arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi
index f370f03..a6534c4 100644
--- a/arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi
+++ b/arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi
@@ -151,7 +151,7 @@
 			#size-cells = <2>;
 			#interrupt-cells = <1>;
 			device_type = "pci";
-			bus-range = <0 0xff>;
+			bus-range = <0 0x7f>;
 			msi-parent = <&v2m0>;
 			reg = <0 0xf0000000 0 0x10000000>;
 
-- 
1.9.3


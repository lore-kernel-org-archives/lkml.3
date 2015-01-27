Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbbA0Kwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:52:39 -0500
Received: from mail-am1on0135.outbound.protection.outlook.com ([157.56.112.135]:50613
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753174AbbA0Kwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:52:37 -0500
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
To: <mark.rutland@arm.com>
CC: <stefan@agner.ch>, <shawn.guo@linaro.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <linux@arm.linux.org.uk>, <broonie@kernel.org>,
        <B44548@freescale.com>, <Li.Xiubo@freescale.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-spi@vger.kernel.org>,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Subject: [PATCH 1/7] ARM: vf610: add second DSPI instance
Date: Tue, 27 Jan 2015 16:27:18 +0530
Message-ID: <1422356244-15629-2-git-send-email-bhuvanchandra.dv@toradex.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422356244-15629-1-git-send-email-bhuvanchandra.dv@toradex.com>
References: <1422356244-15629-1-git-send-email-bhuvanchandra.dv@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [115.115.225.206]
X-ClientProxiedBy: HKXPR03CA001.apcprd03.prod.outlook.com (10.242.96.21) To
 AMSPR05MB262.eurprd05.prod.outlook.com (10.242.95.19)
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=toradex.com;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:AMSPR05MB262;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:AMSPR05MB262;
X-Forefront-PRVS: 046985391D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(92566002)(229853001)(48376002)(19580395003)(122386002)(40100003)(19580405001)(50986999)(50466002)(87976001)(50226001)(53416004)(86362001)(47776003)(42186005)(36756003)(33646002)(77156002)(76176999)(62966003)(2950100001)(110136001)(46102003)(77096005)(2351001)(66066001)(7059030);DIR:OUT;SFP:1102;SCL:1;SRVR:AMSPR05MB262;H:dvb.toradex.int;FPR:;SPF:None;MLV:sfv;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:AMSPR05MB262;
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2015 10:52:21.1502 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMSPR05MB262
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
---
 arch/arm/boot/dts/vf500.dtsi |  4 ++++
 arch/arm/boot/dts/vfxxx.dtsi | 11 +++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/vf500.dtsi b/arch/arm/boot/dts/vf500.dtsi
index 1dbf8d2..f5f807c 100644
--- a/arch/arm/boot/dts/vf500.dtsi
+++ b/arch/arm/boot/dts/vf500.dtsi
@@ -66,6 +66,10 @@
 	interrupts = <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>;
 };
 
+&dspi1 {
+	interrupts = <GIC_SPI 68 IRQ_TYPE_LEVEL_HIGH>;
+};
+
 &edma0 {
 	interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
 			<GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
index a29c7ce..789744b 100644
--- a/arch/arm/boot/dts/vfxxx.dtsi
+++ b/arch/arm/boot/dts/vfxxx.dtsi
@@ -139,6 +139,17 @@
 				status = "disabled";
 			};
 
+			dspi1: dspi1@4002d000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "fsl,vf610-dspi";
+				reg = <0x4002d000 0x1000>;
+				clocks = <&clks VF610_CLK_DSPI1>;
+				clock-names = "dspi";
+				spi-num-chipselects = <5>;
+				status = "disabled";
+			};
+
 			sai2: sai@40031000 {
 				compatible = "fsl,vf610-sai";
 				reg = <0x40031000 0x1000>;
-- 
2.2.2


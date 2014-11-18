Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaKRKdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:33:14 -0500
Received: from mail-bn1bn0106.outbound.protection.outlook.com ([157.56.110.106]:12617
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753469AbaKRKcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:32:35 -0500
From: Yuan Yao <yao.yuan@freescale.com>
To: <wsa@the-dreams.de>, <marex@denx.de>
CC: <LW@KARO-electronics.de>, <mark.rutland@arm.com>,
        <fugang.duan@freescale.com>, <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-i2c@vger.kernel.org>
Subject: [PATCH v11 2/3] Documentation:add DMA support for freescale i2c driver
Date: Tue, 18 Nov 2014 18:31:06 +0800
Message-ID: <1416306667-15673-3-git-send-email-yao.yuan@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1416306667-15673-1-git-send-email-yao.yuan@freescale.com>
References: <1416306667-15673-1-git-send-email-yao.yuan@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(106466001)(104016003)(31966008)(105606002)(62966003)(77156002)(36756003)(99396003)(120916001)(102836001)(95666004)(46102003)(229853001)(107046002)(104166001)(33646002)(50226001)(92726001)(93916002)(92566001)(84676001)(87936001)(86362001)(4396001)(50466002)(48376002)(87286001)(21056001)(89996001)(97736003)(88136002)(50986999)(47776003)(20776003)(68736004)(6806004)(19580395003)(64706001)(19580405001)(44976005)(76176999);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB379;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB379;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB379;
X-Forefront-PRVS: 039975700A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yao.yuan@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB379;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add i2c dts node properties for eDMA support, them depend on the eDMA driver.

Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
---
 Documentation/devicetree/bindings/i2c/i2c-imx.txt | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-imx.txt b/Documentation/devicetree/bindings/i2c/i2c-imx.txt
index 4a8513e..52d37fd 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-imx.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-imx.txt
@@ -11,6 +11,8 @@ Required properties:
 Optional properties:
 - clock-frequency : Constains desired I2C/HS-I2C bus clock frequency in Hz.
   The absence of the propoerty indicates the default frequency 100 kHz.
+- dmas: A list of two dma specifiers, one for each entry in dma-names.
+- dma-names: should contain "tx" and "rx".
 
 Examples:
 
@@ -26,3 +28,12 @@ i2c@70038000 { /* HS-I2C on i.MX51 */
 	interrupts = <64>;
 	clock-frequency = <400000>;
 };
+
+i2c0: i2c@40066000 { /* i2c0 on vf610 */
+	compatible = "fsl,vf610-i2c";
+	reg = <0x40066000 0x1000>;
+	interrupts =<0 71 0x04>;
+	dmas = <&edma0 0 50>,
+		<&edma0 0 51>;
+	dma-names = "rx","tx";
+};
-- 
2.1.0.27.g96db324


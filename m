Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbaHEKpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:45:00 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:21509
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754480AbaHEKo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:44:57 -0400
From: Yuan Yao <yao.yuan@freescale.com>
To: <wsa@the-dreams.de>, <marex@denx.de>
CC: <LW@KARO-electronics.de>, <mark.rutland@arm.com>, <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-i2c@vger.kernel.org>
Subject: [PATCH v6 2/2] Documentation:add DMA support for freescale i2c driver
Date: Tue, 5 Aug 2014 17:56:03 +0800
Message-ID: <1407232563-10856-3-git-send-email-yao.yuan@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1407232563-10856-1-git-send-email-yao.yuan@freescale.com>
References: <1407232563-10856-1-git-send-email-yao.yuan@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(19580395003)(86362001)(69596002)(68736004)(93916002)(83322001)(19580405001)(62966002)(105606002)(81156004)(106466001)(87286001)(88136002)(21056001)(74502001)(87936001)(4396001)(79102001)(85852003)(74662001)(50226001)(99396002)(89996001)(81542001)(31966008)(84676001)(83072002)(95666004)(92726001)(76176999)(36756003)(50986999)(229853001)(44976005)(47776003)(6806004)(102836001)(81342001)(50466002)(77156001)(85306004)(92566001)(107046002)(20776003)(76482001)(64706001)(104016003)(104166001)(77982001)(80022001)(97736001)(26826002)(46102001)(48376002)(33646002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB571;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02945962BD
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yao.yuan@freescale.com; 
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
1.8.4


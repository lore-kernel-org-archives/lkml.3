Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbaHMKhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:37:35 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:4339
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752587AbaHMKgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:36:22 -0400
From: Yuan Yao <yao.yuan@freescale.com>
To: <wsa@the-dreams.de>, <marex@denx.de>
CC: <LW@KARO-electronics.de>, <mark.rutland@arm.com>,
        <fugang.duan@freescale.com>, <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-i2c@vger.kernel.org>
Subject: [PATCH v7 2/2] Documentation:add DMA support for freescale i2c driver
Date: Wed, 13 Aug 2014 17:46:55 +0800
Message-ID: <1407923215-3749-3-git-send-email-yao.yuan@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1407923215-3749-1-git-send-email-yao.yuan@freescale.com>
References: <1407923215-3749-1-git-send-email-yao.yuan@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(33646002)(46102001)(81542001)(21056001)(76176999)(36756003)(85852003)(81342001)(99396002)(97736001)(83072002)(89996001)(102836001)(50226001)(106466001)(68736004)(229853001)(4396001)(107046002)(76482001)(62966002)(26826002)(83322001)(47776003)(19580405001)(20776003)(77982001)(48376002)(19580395003)(95666004)(6806004)(86362001)(88136002)(64706001)(50466002)(80022001)(77156001)(92566001)(85306004)(84676001)(92726001)(31966008)(50986999)(87286001)(87936001)(79102001)(105606002)(44976005)(74502001)(74662001)(104166001)(93916002)(104016003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB378;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0302D4F392
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
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


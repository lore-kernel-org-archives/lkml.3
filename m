Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbaEICuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 22:50:39 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:43618
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752577AbaEICuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 22:50:35 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <gregkh@linuxfoundation.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        "Xiubo Li" <Li.Xiubo@freescale.com>
Subject: [PATCHv4 1/2] dt/bindings: Add the DT binding documentation for endianness
Date: Fri, 9 May 2014 10:04:32 +0800
Message-ID: <1399601073-19278-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1399601073-19278-1-git-send-email-Li.Xiubo@freescale.com>
References: <1399601073-19278-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(189002)(199002)(77156001)(19580395003)(44976005)(20776003)(47776003)(6806004)(19580405001)(83322001)(68736004)(69596002)(64706001)(36756003)(80022001)(76482001)(46102001)(77982001)(21056001)(86362001)(93916002)(50226001)(4396001)(48376002)(74662001)(31966008)(74502001)(50466002)(87936001)(88136002)(87286001)(79102001)(83072002)(89996001)(92726001)(85852003)(2201001)(92566001)(76176999)(2009001)(99396002)(50986999)(77096999)(81542001)(62966002)(81342001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB506;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 02065A9E77
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device-Tree binding for device endianness

The endianness mode of CPU & Device scenarios:
Index    CPU       Device     Endianness properties
------------------------------------------------------------
1        LE        LE         -
2        LE        BE         'big-endian{,-*}'
3        BE        BE         -
4        BE        LE         'little-endian{,-*}'

{big,little}-endian{,-*}: these are boolean properties, if absent
meaning that the CPU and the Device are in the same endianness mode.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 .../devicetree/bindings/endianness/endianness.txt  | 48 ++++++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/endianness/endianness.txt

diff --git a/Documentation/devicetree/bindings/endianness/endianness.txt b/Documentation/devicetree/bindings/endianness/endianness.txt
new file mode 100644
index 0000000..cc5f7f8
--- /dev/null
+++ b/Documentation/devicetree/bindings/endianness/endianness.txt
@@ -0,0 +1,48 @@
+Device-Tree binding for device endianness
+
+The endianness mode of CPU & Device scenarios:
+Index    CPU       Device     Endianness properties
+------------------------------------------------------------
+1        LE        LE         -
+2        LE        BE         'big-endian{,-*}'
+3        BE        BE         -
+4        BE        LE         'little-endian{,-*}'
+
+For one device driver, which will run in different scenarios above
+on different SoCs using the devicetree, we need one way to simplify
+this.
+
+Required properties:
+- {big,little}-endian{,-*}: these are boolean properties, if absent
+  meaning that the CPU and the Device are in the same endianness mode.
+
+Examples:
+Scenario 1 : CPU in LE mode & device in LE mode.
+dev: dev@40031000 {
+	      compatible = "name";
+	      reg = <0x40031000 0x1000>;
+	      ...
+};
+
+Scenario 2 : CPU in LE mode & device in BE mode.
+dev: dev@40031000 {
+	      compatible = "name";
+	      reg = <0x40031000 0x1000>;
+	      ...
+	      big-endian{,-*};
+};
+
+Scenario 3 : CPU in BE mode & device in BE mode.
+dev: dev@40031000 {
+	      compatible = "name";
+	      reg = <0x40031000 0x1000>;
+	      ...
+};
+
+Scenario 4 : CPU in BE mode & device in LE mode.
+dev: dev@40031000 {
+	      compatible = "name";
+	      reg = <0x40031000 0x1000>;
+	      ...
+	      little-endian{,-*};
+};
-- 
1.8.4


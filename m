Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbaDWHby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:31:54 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:6845
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756528AbaDWHao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:30:44 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <rob@landley.net>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 1/3] dt/bindings: Add the DT binding documentation for endianness
Date: Wed, 23 Apr 2014 14:46:33 +0800
Message-ID: <1398235595-13370-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1398235595-13370-1-git-send-email-Li.Xiubo@freescale.com>
References: <1398235595-13370-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(89996001)(77156001)(48376002)(46102001)(80022001)(36756003)(88136002)(85852003)(83072002)(86362001)(99396002)(20776003)(50466002)(77096999)(76176999)(50986999)(6806004)(77982001)(81342001)(62966002)(81542001)(19580405001)(83322001)(87936001)(19580395003)(50226001)(44976005)(79102001)(92726001)(47776003)(92566001)(74502001)(74662001)(31966008)(76482001)(87286001)(4396001)(80976001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB498;H:az84smr01.freescale.net;FPR:CA5D5FFF.2D860429.40459B36.86A0E241.201A8;MLV:sfv;PTR:gate-az5.freescale.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 01901B3451
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 .../devicetree/bindings/endianness/endianness.txt  | 55 ++++++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/endianness/endianness.txt

diff --git a/Documentation/devicetree/bindings/endianness/endianness.txt b/Documentation/devicetree/bindings/endianness/endianness.txt
new file mode 100644
index 0000000..64f1d5e
--- /dev/null
+++ b/Documentation/devicetree/bindings/endianness/endianness.txt
@@ -0,0 +1,55 @@
+Device-Tree binding for device endianness
+
+The endianness mode of CPU & Device scenarios:
+  Index    CPU      Device
+  ------------------------
+  1        LE         LE
+  2        LE         BE
+  3        BE         BE
+  4        BE         LE
+
+For one device driver, which will run in different scenarios above
+on different SoCs using the devicetree, we need one way to simplify
+this.
+
+Required properties:
+- [prefix]-endian: this is one string property and must be one
+  of 'be', 'le' and 'native' if it is present.
+
+The endianness mode:
+  'le' : device is in little endian mode,
+  'be' : device is in big endian mode,
+  'native' : device is in the same endian mode with the CPU.
+
+Examples:
+Scenario 1 : CPU in LE mode & device in LE mode.
+dev: dev@40031000 {
+	      compatible = "name";
+	      reg = <0x40031000 0x1000>;
+	      ...
+	      [prefix]-endian = 'native';
+};
+
+Scenario 2 : CPU in LE mode & device in BE mode.
+dev: dev@40031000 {
+	      compatible = "name";
+	      reg = <0x40031000 0x1000>;
+	      ...
+	      [prefix]-endian = 'be';
+};
+
+Scenario 3 : CPU in BE mode & device in BE mode.
+dev: dev@40031000 {
+	      compatible = "name";
+	      reg = <0x40031000 0x1000>;
+	      ...
+	      [prefix]-endian = 'native';
+};
+
+Scenario 4 : CPU in BE mode & device in LE mode.
+dev: dev@40031000 {
+	      compatible = "name";
+	      reg = <0x40031000 0x1000>;
+	      ...
+	      [prefix]-endian = 'le';
+};
-- 
1.8.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448AbaDWHbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:31:09 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:56834
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751275AbaDWHbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:31:00 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <rob@landley.net>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 2/3] regmap: Add the DT binding documentation for endianness
Date: Wed, 23 Apr 2014 14:46:34 +0800
Message-ID: <1398235595-13370-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1398235595-13370-1-git-send-email-Li.Xiubo@freescale.com>
References: <1398235595-13370-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(77982001)(79102001)(83072002)(89996001)(86362001)(87286001)(81542001)(85852003)(20776003)(47776003)(80022001)(36756003)(92726001)(92566001)(31966008)(74502001)(81342001)(74662001)(19580395003)(50466002)(62966002)(48376002)(87936001)(80976001)(44976005)(83322001)(76482001)(46102001)(50986999)(76176999)(88136002)(50226001)(77096999)(19580405001)(77156001)(4396001)(99396002)(6806004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB507;H:az84smr01.freescale.net;FPR:95A6DBF.25E60459.73E59B33.94A49211.20171;MLV:sfv;PTR:gate-az5.freescale.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 01901B3451
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 .../bindings/regmap/regmap-endianness.txt          | 48 ++++++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regmap/regmap-endianness.txt

diff --git a/Documentation/devicetree/bindings/regmap/regmap-endianness.txt b/Documentation/devicetree/bindings/regmap/regmap-endianness.txt
new file mode 100644
index 0000000..1d838c5
--- /dev/null
+++ b/Documentation/devicetree/bindings/regmap/regmap-endianness.txt
@@ -0,0 +1,48 @@
+Device-Tree bindings for regmap endianness
+
+Required properties:
+- regmap-reg-endian: register endianness, see ../endianness/endianness.txt
+  for detail.
+- regmap-val-endian: value endianness, see ../endianness/endianness.txt for
+  detail.
+
+The Endianness flags supported by regmap:
+DT properties           Macros
+----------------------------------------
+    'le'          REGMAP_ENDIAN_LITTLE
+    'be'          REGMAP_ENDIAN_BIG
+    'native'      REGMAP_ENDIAN_NATIVE
+    Absent        REGMAP_ENDIAN_DEFAULT
+
+Examples for using the regmap-mmio:
+Scenario 1 : CPU in LE mode & device in LE mode.
+dev: dev@40031000 {
+	      compatible = "name";
+	      reg = <0x40031000 0x1000>;
+	      ...
+	      regmap-val-endian = 'native'; or just absent.
+};
+
+Scenario 2 : CPU in LE mode & device in BE mode.
+dev: dev@40031000 {
+	      compatible = "name";
+	      reg = <0x40031000 0x1000>;
+	      ...
+	      regmap-val-endian = 'be';
+};
+
+Scenario 3 : CPU in BE mode & device in BE mode.
+dev: dev@40031000 {
+	      compatible = "name";
+	      reg = <0x40031000 0x1000>;
+	      ...
+	      regmap-val-endian = 'native'; or just absent.
+};
+
+Scenario 4 : CPU in BE mode & device in LE mode.
+dev: dev@40031000 {
+	      compatible = "name";
+	      reg = <0x40031000 0x1000>;
+	      ...
+	      regmap-val-endian = 'le';
+};
-- 
1.8.4


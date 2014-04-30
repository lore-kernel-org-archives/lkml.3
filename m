Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbaD3Jgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:36:54 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:31936
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758569AbaD3Jgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:36:49 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <mark.rutland@arm.com>, <broonie@kernel.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rob@landley.net>, <richardcochran@gmail.com>
CC: <gregkh@linuxfoundation.org>, <mpa@pengutronix.de>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv3 resend 1/2] dt/bindings: Add the DT binding documentation for endianness
Date: Wed, 30 Apr 2014 16:52:00 +0800
Message-ID: <1398847921-9322-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1398847921-9322-1-git-send-email-Li.Xiubo@freescale.com>
References: <1398847921-9322-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(19580395003)(77982001)(50226001)(44976005)(86362001)(20776003)(74662001)(80022001)(19580405001)(76176999)(92566001)(89996001)(83322001)(50466002)(85852003)(101416001)(93916002)(48376002)(81342001)(31966008)(2201001)(80976001)(99396002)(47776003)(77096999)(46102001)(81542001)(77156001)(83072002)(87936001)(88136002)(79102001)(6806004)(87286001)(74502001)(50986999)(62966002)(76482001)(36756003)(92726001)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB506;H:tx30smr01.am.freescale.net;FPR:C15E5FFF.2486242C.43579B0A.84B6F211.2018A;MLV:sfv;PTR:gate-tx3.freescale.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0197AFBD92
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 .../devicetree/bindings/endianness/endianness.txt  | 47 ++++++++++++++++++++++
 1 file changed, 47 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/endianness/endianness.txt

diff --git a/Documentation/devicetree/bindings/endianness/endianness.txt b/Documentation/devicetree/bindings/endianness/endianness.txt
new file mode 100644
index 0000000..49458a1
--- /dev/null
+++ b/Documentation/devicetree/bindings/endianness/endianness.txt
@@ -0,0 +1,47 @@
+Device-Tree binding for device endianness
+
+The endianness mode of CPU & Device scenarios:
+Index    CPU       Device     Endianess flag for DT bool property
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
+- {big,little}-endian{,-*}: this is one boolean property.
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaJOTEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:04:51 -0400
Received: from mail-bl2on0057.outbound.protection.outlook.com ([65.55.169.57]:38336
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751666AbaJOTBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:01:50 -0400
From: <atull@opensource.altera.com>
To: <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v6 1/4] hwmon: ltc2978: device tree bindings documentation
Date: Wed, 15 Oct 2014 13:55:07 -0500
Message-ID: <1413399310-19277-2-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413399310-19277-1-git-send-email-atull@opensource.altera.com>
References: <1413399310-19277-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR08CA0047.namprd08.prod.outlook.com (10.141.200.27) To
 BY2PR03MB315.namprd03.prod.outlook.com (10.141.139.25)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB315;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(86362001)(77156001)(104166001)(76176999)(31966008)(21056001)(85852003)(89996001)(86152002)(101416001)(19580395003)(48376002)(19580405001)(87286001)(50466002)(92726001)(69596002)(92566001)(50986999)(62966002)(33646002)(87976001)(95666004)(99396003)(20776003)(64706001)(105586002)(120916001)(77096002)(102836001)(50226001)(229853001)(122386002)(107046002)(4396001)(106356001)(80022003)(53416004)(66066001)(97736003)(85306004)(46102003)(42186005)(81156004)(76482002)(40100003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB315;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Add device tree bindings documentation for ltc2978.

Signed-off-by: Alan Tull <atull@opensource.altera.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mark Brown <broonie@kernel.org>
---
v2: clean whitespace

v3: list compatible strings in single column
    add vendor as lltc
    mention regulators.txt instead of documenting regulator-name
    s/vout_en/vout/
    remove size_cells, address-cells
    use node name to identify regulators
---
 .../devicetree/bindings/hwmon/ltc2978.txt          |   39 ++++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hwmon/ltc2978.txt

diff --git a/Documentation/devicetree/bindings/hwmon/ltc2978.txt b/Documentation/devicetree/bindings/hwmon/ltc2978.txt
new file mode 100644
index 0000000..16c1227
--- /dev/null
+++ b/Documentation/devicetree/bindings/hwmon/ltc2978.txt
@@ -0,0 +1,39 @@
+ltc2978
+
+Required properties:
+- compatible: should contain one of:
+  * "lltc,ltc2974"
+  * "lltc,ltc2977"
+  * "lltc,ltc2978"
+  * "lltc,ltc3880"
+  * "lltc,ltc3883"
+  * "lltc,ltm4676"
+- reg: I2C slave address
+
+Optional properties:
+- regulators: A node that houses a sub-node for each regulator controlled by
+  the device. Each sub-node is identified using the node's name, with valid
+  values listed below. The content of each sub-node is defined by the
+  standard binding for regulators; see regulator.txt.
+
+Valid names of regulators depend on number of supplies supported per device:
+  * ltc2974 : vout0 - vout3
+  * ltc2977 : vout0 - vout7
+  * ltc2978 : vout0 - vout7
+  * ltc3880 : vout0 - vout1
+  * ltc3883 : vout0
+  * ltm4676 : vout0 - vout1
+
+Example:
+ltc2978@5e {
+	compatible = "ltc2978";
+	reg = <0x5e>;
+	regulators {
+		vout0 {
+			regulator-name = "FPGA-2.5V";
+		};
+		vout2 {
+			regulator-name = "FPGA-1.5V";
+		};
+	};
+};
-- 
1.7.9.5


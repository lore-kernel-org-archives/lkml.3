Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaJBSoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:44:09 -0400
Received: from mail-bl2on0095.outbound.protection.outlook.com ([65.55.169.95]:17557
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751857AbaJBSoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:44:06 -0400
X-Greylist: delayed 73056 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Oct 2014 14:44:06 EDT
From: <atull@opensource.altera.com>
To: <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v5 1/4] hwmon: ltc2978: device tree bindings documentation
Date: Thu, 2 Oct 2014 13:37:48 -0500
Message-ID: <1412275071-6417-2-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412275071-6417-1-git-send-email-atull@opensource.altera.com>
References: <1412275071-6417-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR06CA048.namprd06.prod.outlook.com (10.141.250.166) To
 BL2PR03MB305.namprd03.prod.outlook.com (10.141.68.13)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB305;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(62966002)(77156001)(81156004)(85852003)(89996001)(120916001)(105586002)(77096002)(107046002)(76482002)(106356001)(31966008)(10300001)(88136002)(87286001)(20776003)(47776003)(99396003)(64706001)(87976001)(101416001)(33646002)(21056001)(229853001)(66066001)(104166001)(93916002)(86362001)(53416004)(102836001)(97736003)(69596002)(42186005)(50466002)(92726001)(48376002)(95666004)(46102003)(80022003)(85306004)(50226001)(92566001)(50986999)(76176999)(4396001)(86152002)(19580405001)(19580395003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB305;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Add device tree bindings documentation for ltc2978.

Signed-off-by: Alan Tull <atull@opensource.altera.com>
---
v2: clean whitespace
---
 .../devicetree/bindings/hwmon/ltc2978.txt          |   41 ++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hwmon/ltc2978.txt

diff --git a/Documentation/devicetree/bindings/hwmon/ltc2978.txt b/Documentation/devicetree/bindings/hwmon/ltc2978.txt
new file mode 100644
index 0000000..b2d9c4d
--- /dev/null
+++ b/Documentation/devicetree/bindings/hwmon/ltc2978.txt
@@ -0,0 +1,41 @@
+ltc2978
+
+Required properties:
+ - compatible: one of: ltc2974, ltc2977, ltc2978, ltc3880, ltc3883, ltm4676
+ - reg: I2C address
+
+Optional properties:
+ Name of the optional regulator subnode must be "regulators".
+  - #address-cells must be 1.
+  - #size-cells must be 0.
+
+ For each regulator:
+  - reg: regulator number
+  - regulator-compatible: must be vout_en<regulator number> such as vout_en3
+    valid range is:
+      ltc2977, ltc2978 : vout_en0 - vout_en7
+      ltc2974          : vout_en0 - vout_en3
+      ltc3880, ltm4676 : vout_en0 - vout_en1
+      ltc3883          : vout_en0 only
+  - regulator-name: arbitrary name for regulator
+
+Example:
+ltc2978@5e {
+	compatible = "ltc2978";
+	reg = <0x5e>;
+	regulators {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vdacp0_reg: regulator@0 {
+			reg = <0>;
+			regulator-compatible = "vout_en0";
+			regulator-name = "FPGA-2.5V";
+		};
+		vdacp2_reg: regulator@2 {
+			reg = <2>;
+			regulator-compatible = "vout_en2";
+			regulator-name = "FPGA-1.5V";
+		};
+	};
+};
-- 
1.7.9.5


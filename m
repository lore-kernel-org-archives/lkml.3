Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab3IIK3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:29:18 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8144 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab3IIK2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:28:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 09 Sep 2013 03:25:55 -0700
From: Wei Ni <wni@nvidia.com>
To: <khali@linux-fr.org>, <linux@roeck-us.net>
CC: <broonie@kernel.org>, <swarren@wwwdotorg.org>, <lm-sensors@lm-sensors.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Wei Ni <wni@nvidia.com>
Subject: [PATCH v3 2/2] Documentation: dt: hwmon: add OF document for LM90
Date: Mon, 9 Sep 2013 18:29:12 +0800
Message-ID: <1378722552-10357-3-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378722552-10357-1-git-send-email-wni@nvidia.com>
References: <1378722552-10357-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add OF document for LM90 in Documentation/devicetree/.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 Documentation/devicetree/bindings/hwmon/lm90.txt |   44 ++++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hwmon/lm90.txt

diff --git a/Documentation/devicetree/bindings/hwmon/lm90.txt b/Documentation/devicetree/bindings/hwmon/lm90.txt
new file mode 100644
index 0000000..5570875
--- /dev/null
+++ b/Documentation/devicetree/bindings/hwmon/lm90.txt
@@ -0,0 +1,44 @@
+* LM90 series thermometer.
+
+Required node properties:
+- compatible: manufacture and chip name, one of
+		"<manufacture>,adm1032"
+		"<manufacture>,adt7461"
+		"<manufacture>,adt7461a"
+		"<manufacture>,g781"
+		"<manufacture>,lm90"
+		"<manufacture>,lm86"
+		"<manufacture>,lm89"
+		"<manufacture>,lm99"
+		"<manufacture>,max6646"
+		"<manufacture>,max6647"
+		"<manufacture>,max6649"
+		"<manufacture>,max6657"
+		"<manufacture>,max6658"
+		"<manufacture>,max6659"
+		"<manufacture>,max6680"
+		"<manufacture>,max6681"
+		"<manufacture>,max6695"
+		"<manufacture>,max6696"
+		"<manufacture>,nct1008"
+		"<manufacture>,w83l771"
+		"<manufacture>,sa56004"
+
+- reg: I2C bus address of the device
+
+Optional properties:
+- vcc-supply: vcc regulator for the supply voltage.
+              If this is not set, assuming vdd is always powered.
+- interrupts: Contains a single interrupt specifier which describes the
+              LM90 pin6 output.
+              See interrupt-controller/interrupts.txt for the format.
+
+Example LM90 node:
+
+temp-sensor {
+	compatible = "onnn,nct1008";
+	reg = <0x4c>;
+	vcc-supply = <&palmas_ldo6_reg>;
+	interrupt-parent = <&gpio>;
+	interrupts = <TEGRA_GPIO(O, 4) IRQ_TYPE_LEVEL_LOW>;
+}
-- 
1.7.9.5


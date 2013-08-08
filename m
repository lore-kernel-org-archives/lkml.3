Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933831Ab3HHG5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 02:57:15 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8157 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933531Ab3HHG5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 02:57:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 07 Aug 2013 23:57:03 -0700
From: Wei Ni <wni@nvidia.com>
To: <khali@linux-fr.org>, <linux@roeck-us.net>, <swarren@wwwdotorg.org>
CC: <MLongnecker@nvidia.com>, <linux-arm-kernel@lists.infradead.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH v2 3/3] Documentation: dt: hwmon: add OF document for lm90
Date: Thu, 8 Aug 2013 14:56:31 +0800
Message-ID: <1375944991-29182-4-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375944991-29182-1-git-send-email-wni@nvidia.com>
References: <1375944991-29182-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add OF document for lm90 in Documentation/devicetree/.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 Documentation/devicetree/bindings/hwmon/lm90.txt |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hwmon/lm90.txt

diff --git a/Documentation/devicetree/bindings/hwmon/lm90.txt b/Documentation/devicetree/bindings/hwmon/lm90.txt
new file mode 100644
index 0000000..8024f11
--- /dev/null
+++ b/Documentation/devicetree/bindings/hwmon/lm90.txt
@@ -0,0 +1,20 @@
+* LM90 series thermometer.
+
+Required node properties:
+- compatible: manufacture and chip name,
+              which are listed in the Documentation/hwmon/lm90
+- reg: I2C bus address of the device
+
+Optional properties:
+- vdd-supply: vdd regulator for the supply voltage. If this is not set,
+              assuming vdd is always powered.
+- interrupts: lm90 can support interrupt mode, you can set interrupt here.
+
+Example lm90 node:
+
+nct1008 {
+	compatible = "onnn,nct1008";
+	reg = <0x4c>;
+	vdd-supply = <&palmas_ldo6_reg>;
+	interrupt-parent = <&gpio>;
+	interrupts = <TEGRA_GPIO(O, 4) IRQ_TYPE_LEVEL_LOW>;
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965800AbaH1KtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:49:25 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.142]:7462 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965688AbaH1KtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:49:22 -0400
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-14.tower-178.messagelabs.com!1409222958!36115150!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <5b66745f0154bfa9b03664a473aa15672ebc5f8b.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Thu, 28 Aug 2014 11:49:13 +0100
Subject: [PATCH v2 6/7] power: da9150: Add DT binding documentation for charger
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, <linux-iio@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
CC: <linux-kernel@vger.kernel.org>, <support.opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
---
 .../devicetree/bindings/power/da9150-charger.txt   | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power/da9150-charger.txt

diff --git a/Documentation/devicetree/bindings/power/da9150-charger.txt b/Documentation/devicetree/bindings/power/da9150-charger.txt
new file mode 100644
index 0000000..f390666
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/da9150-charger.txt
@@ -0,0 +1,26 @@
+Dialog Semiconductor DA9150 Charger Power Supply bindings
+
+Required properties:
+- compatible: "dlg,da9150-charger" for DA9150 Charger Power Supply
+
+Optional properties:
+- io-channels: List of phandle and IIO specifier pairs
+- io-channel-names: List of channel names used by charger
+      ["CHAN_IBUS", "CHAN_VBUS", "CHAN_TJUNC", "CHAN_VBAT"]
+  (See Documentation/devicetree/bindings/iio/iio-bindings.txt for further info)
+
+
+Example:
+
+	da9150-charger {
+		compatible = "dlg,da9150-charger";
+
+		io-channels = <&gpadc 0>,
+			      <&gpadc 2>,
+			      <&gpadc 8>,
+			      <&gpadc 5>;
+		io-channel-names = "CHAN_IBUS",
+				   "CHAN_VBUS",
+				   "CHAN_TJUNC",
+				   "CHAN_VBAT";
+	};
--
1.9.3


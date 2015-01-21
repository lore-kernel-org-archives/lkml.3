Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbbAUPsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:48:45 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.177]:25769 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753947AbbAUPrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:47:10 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-6.tower-38.messagelabs.com!1421855227!27179768!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <2f011303978f220998ced914874902601edb01bf.1421854282.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1421854282.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1421854282.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Wed, 21 Jan 2015 15:47:03 +0000
Subject: [PATCH v6 6/7] power: da9150: Add DT binding documentation for charger
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        <linux-iio@vger.kernel.org>, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
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


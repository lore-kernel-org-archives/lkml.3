Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbaIWKyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:54:07 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.141]:47314 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747AbaIWKyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:54:03 -0400
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-14.tower-179.messagelabs.com!1411469622!34017039!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.12.2; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <598abe01ba3c1cc6d208c1b15aa5d4a22971bdd5.1411396719.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1411396718.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1411396718.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Tue, 23 Sep 2014 11:53:40 +0100
Subject: [PATCH 6/8] power: da9150: Add DT binding documentation for charger
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, <linux-iio@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, <linux-api@vger.kernel.org>
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


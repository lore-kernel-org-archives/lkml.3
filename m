Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbaFKLWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:22:14 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.169]:61714 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750817AbaFKLWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:22:12 -0400
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-16.tower-38.messagelabs.com!1402485096!3045582!2
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <d87d24fcc25658ef50360b69d3efc085ee3270a7.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Wed, 11 Jun 2014 12:11:36 +0100
Subject: [PATCH 7/8] power: da9150: Add DT binding documentation for charger
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, <linux-iio@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <support.opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
---
 .../devicetree/bindings/power/da9150-charger.txt   | 29 ++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power/da9150-charger.txt

diff --git a/Documentation/devicetree/bindings/power/da9150-charger.txt b/Documentation/devicetree/bindings/power/da9150-charger.txt
new file mode 100644
index 0000000..079931b
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/da9150-charger.txt
@@ -0,0 +1,29 @@
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
+- dlg,invalid-tbat: bool flag to indicate no valid TBAT pin provided in system.
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
+
+		dlg,invalid-tbat;
+	};
--
1.9.3


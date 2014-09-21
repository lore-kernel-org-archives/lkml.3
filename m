Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbaIUUGi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 16:06:38 -0400
Received: from gloria.sntech.de ([95.129.55.99]:37238 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbaIUUGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 16:06:20 -0400
From: Heiko Stuebner <heiko@sntech.de>
To: sre@kernel.org, dbaryshkov@gmail.com, dwmw2@infradead.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, dianders@chromium.org, heiko@sntech.de,
        Heiko Stuebner <heiko.stuebner@bq.com>
Subject: [PATCH v2 1/3] dt-bindings: document gpio-charger bindings
Date: Sun, 21 Sep 2014 22:05:21 +0200
Message-Id: <1411329923-15912-2-git-send-email-heiko@sntech.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411329923-15912-1-git-send-email-heiko@sntech.de>
References: <1411329923-15912-1-git-send-email-heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@bq.com>

This documents the binding for the gpio-charger power-supply.

Signed-off-by: Heiko Stuebner <heiko.stuebner@bq.com>
---
 .../bindings/power_supply/gpio-charger.txt         | 27 ++++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power_supply/gpio-charger.txt

diff --git a/Documentation/devicetree/bindings/power_supply/gpio-charger.txt b/Documentation/devicetree/bindings/power_supply/gpio-charger.txt
new file mode 100644
index 0000000..adbb5dc
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/gpio-charger.txt
@@ -0,0 +1,27 @@
+gpio-charger
+
+Required properties :
+ - compatible : "gpio-charger"
+ - gpios : GPIO indicating the charger presence.
+   See GPIO binding in bindings/gpio/gpio.txt .
+ - charger-type : power supply type, one of
+     unknown
+     battery
+     ups
+     mains
+     usb-sdp (USB standard downstream port)
+     usb-dcp (USB dedicated charging port)
+     usb-cdp (USB charging downstream port)
+     usb-aca (USB accessory charger adapter)
+
+Example:
+
+	usb_charger: charger {
+		compatible = "gpio-charger";
+		charger-type = "usb-sdp";
+		gpios = <&gpf0 2 0 0 0>;
+	}
+
+	battery {
+		power-supplies = <&usb_charger>;
+	};
-- 
1.9.0


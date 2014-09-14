Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbaINTUz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 15:20:55 -0400
Received: from gloria.sntech.de ([95.129.55.99]:39172 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbaINTUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 15:20:53 -0400
From: Heiko Stuebner <heiko@sntech.de>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 3/5] dt-bindings: add devicetree bindings for Fairchild FAN53555 regulators
Date: Sun, 14 Sep 2014 21:23:03 +0200
Message-Id: <1410722585-13393-4-git-send-email-heiko@sntech.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1410722585-13393-1-git-send-email-heiko@sntech.de>
References: <1410722585-13393-1-git-send-email-heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the regulator and add a fairchild vendor-prefix.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 .../devicetree/bindings/regulator/fan53555.txt     | 25 ++++++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 2 files changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/fan53555.txt

diff --git a/Documentation/devicetree/bindings/regulator/fan53555.txt b/Documentation/devicetree/bindings/regulator/fan53555.txt
new file mode 100644
index 0000000..2484497
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/fan53555.txt
@@ -0,0 +1,25 @@
+Binding for Fairchild FAN53555 regulators
+
+Required properties:
+  - compatible: "fairchild,fan53555"
+  - reg: I2C address
+
+Optional properties:
+  - fairchild,suspend-regulator: regulator number to use for suspend voltages
+		possible values are either <0> or <1>
+  - fairchild,slew-rate-microvolt: slew rate to use for positive voltage
+		transistions in microvolts per us, possible values are:
+		64000, 32000, 16000, 8000, 4000, 2000, 1000, 500
+  - vin-supply: regulator supplying the vin pin
+
+Example:
+
+	regulator@40 {
+		compatible = "fairchild,fan53555";
+		regulator-name = "fan53555";
+		regulator-min-microvolt = <1000000>;
+		regulator-max-microvolt = <1800000>;
+		vin-supply = <&parent_reg>;
+		fairchild,suspend-regulator = <1>;
+		fairchild,slew-rate-microvolt = <64000>;
+	};
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index ac7269f..99da41b 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -49,6 +49,7 @@ epson	Seiko Epson Corp.
 est	ESTeem Wireless Modems
 eukrea  Eukréa Electromatique
 excito	Excito
+fairchild	Fairchild Semiconductor
 fsl	Freescale Semiconductor
 GEFanuc	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
 gef	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
-- 
2.0.1


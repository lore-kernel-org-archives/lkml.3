Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbaIPTUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:20:42 -0400
Received: from gloria.sntech.de ([95.129.55.99]:56958 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928AbaIPTUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:20:40 -0400
From: Heiko Stuebner <heiko@sntech.de>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH v3 1/3] dt-bindings: add devicetree bindings for Fairchild FAN53555 regulators
Date: Tue, 16 Sep 2014 21:22:52 +0200
Message-Id: <1410895374-18367-2-git-send-email-heiko@sntech.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1410895374-18367-1-git-send-email-heiko@sntech.de>
References: <1410895374-18367-1-git-send-email-heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the regulator and add a fairchild vendor-prefix.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 .../devicetree/bindings/regulator/fan53555.txt     | 23 ++++++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 2 files changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/fan53555.txt

diff --git a/Documentation/devicetree/bindings/regulator/fan53555.txt b/Documentation/devicetree/bindings/regulator/fan53555.txt
new file mode 100644
index 0000000..8a51924
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/fan53555.txt
@@ -0,0 +1,23 @@
+Binding for Fairchild FAN53555 regulators
+
+Required properties:
+  - compatible: "fcs,fan53555"
+  - reg: I2C address
+
+Optional properties:
+  - fcs,suspend-voltage-selector: declare which of the two available
+		voltage selector registers should be used for the suspend
+		voltage. The other one is used for the runtime voltage setting
+		Possible values are either <0> or <1>
+  - vin-supply: regulator supplying the vin pin
+
+Example:
+
+	regulator@40 {
+		compatible = "fcs,fan53555";
+		regulator-name = "fan53555";
+		regulator-min-microvolt = <1000000>;
+		regulator-max-microvolt = <1800000>;
+		vin-supply = <&parent_reg>;
+		fcs,suspend-voltage-selector = <1>;
+	};
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index ac7269f..24b92b3 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -49,6 +49,7 @@ epson	Seiko Epson Corp.
 est	ESTeem Wireless Modems
 eukrea  Eukréa Electromatique
 excito	Excito
+fcs	Fairchild Semiconductor
 fsl	Freescale Semiconductor
 GEFanuc	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
 gef	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
-- 
2.0.1


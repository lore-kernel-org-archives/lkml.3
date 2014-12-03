Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaLCVdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 16:33:45 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:37347 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbaLCVdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 16:33:41 -0500
From: Marek Belisko <marek@goldelico.com>
To: tomi.valkeinen@ti.com
Cc: plagnioj@jcrosoft.com, tony@atomide.com, bcousson@baylibre.com,
        hns@goldelico.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH v4 2/3] Documentation: DT: Add documentation for ti,opa362 bindings
Date: Wed,  3 Dec 2014 22:33:21 +0100
Message-Id: <1417642402-20538-3-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417642402-20538-1-git-send-email-marek@goldelico.com>
References: <1417642402-20538-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 .../devicetree/bindings/video/ti,opa362.txt        | 38 ++++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/ti,opa362.txt

diff --git a/Documentation/devicetree/bindings/video/ti,opa362.txt b/Documentation/devicetree/bindings/video/ti,opa362.txt
new file mode 100644
index 0000000..f96083c
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/ti,opa362.txt
@@ -0,0 +1,38 @@
+OPA362 analog video amplifier
+
+Required properties:
+- compatible: "ti,opa362"
+- enable-gpios: enable/disable output gpio
+
+Required node:
+- Video port 0 for opa362 input
+- Video port 1 for opa362 output
+
+Example:
+
+tv_amp: opa362 {
+	compatible = "ti,opa362";
+	enable-gpios = <&gpio1 23 0>;  /* GPIO to enable video out amplifier */
+
+	ports {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port@0 {
+			reg = <0>;
+			opa_in: endpoint@0 {
+				remote-endpoint = <&venc_out>;
+			};
+		};
+
+		port@1 {
+			reg = <1>;
+			opa_out: endpoint@0 {
+				remote-endpoint = <&tv_connector_in>;
+			};
+		};
+	};
+};
+
+
+
-- 
1.9.1


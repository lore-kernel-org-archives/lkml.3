Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbaKCV77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:59:59 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:47345 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbaKCV7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:59:50 -0500
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bcousson@baylibre.com, tony@atomide.com, linux@arm.linux.org.uk,
        tomi.valkeinen@ti.com, plagnioj@jcrosoft.com, grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, hns@goldelico.com,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH 2/4] Documentation: DT: Add documentation for ti,opa362 bindings
Date: Mon,  3 Nov 2014 22:59:26 +0100
Message-Id: <1415051968-4878-3-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415051968-4878-1-git-send-email-marek@goldelico.com>
References: <1415051968-4878-1-git-send-email-marek@goldelico.com>
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
index 0000000..d7ed11a
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/ti,opa362.txt
@@ -0,0 +1,38 @@
+OPA362 analog video amplifier
+
+Required properties:
+- compatible: "ti,opa362"
+- gpio: enable/disable output gpio
+
+Required node:
+- Video port 0 for opa362 input
+- Video port 1 for opa362 output
+
+Example:
+
+tv_amp: opa362 {
+	 compatible = "ti,opa362";
+	 gpios = <&gpio1 23 0>;  /* GPIO to enable video out amplifier */
+	 
+	label = "opa362";
+	 ports {
+		 #address-cells = <1>;
+		 #size-cells = <0>;
+		 port@0 {
+			 reg = <0>;
+			 opa_in: endpoint@0 {
+				 remote-endpoint = <&venc_out>;
+			 };
+		 };
+
+		 port@1 {
+			 reg = <1>;
+			 opa_out: endpoint@0 {
+				 remote-endpoint = <&tv_connector_in>;
+			 };
+		 };
+	 };
+ };
+
+
+
-- 
1.9.1


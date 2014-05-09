Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbaEIORV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:17:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46297 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756727AbaEIOQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:16:47 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, David Airlie <airlied@linux.ie>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [RFC PATCH 2/2] drm/panel: update simple-panel DT bindings doc with panel desc properties
Date: Fri,  9 May 2014 16:16:42 +0200
Message-Id: <1399645002-18000-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399645002-18000-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1399645002-18000-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document simple-panel description properties and subnodes.

The display-timings definition is the one described in
Documentation/devicetree/bindings/video/display-timing.txt.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 .../devicetree/bindings/panel/simple-panel.txt     | 34 ++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/Documentation/devicetree/bindings/panel/simple-panel.txt b/Documentation/devicetree/bindings/panel/simple-panel.txt
index 1341bbf..3440f78 100644
--- a/Documentation/devicetree/bindings/panel/simple-panel.txt
+++ b/Documentation/devicetree/bindings/panel/simple-panel.txt
@@ -7,6 +7,13 @@ Optional properties:
 - ddc-i2c-bus: phandle of an I2C controller used for DDC EDID probing
 - enable-gpios: GPIO pin to enable or disable the panel
 - backlight: phandle of the backlight device attached to the panel
+- height: the screen height in pixels
+- width: the screen width in pixels
+
+Optional children nodes:
+- display-timings: encode the panel timings.
+  see Documentation/devicetree/bindings/video/display-timing.txt for a full
+  description.
 
 Example:
 
@@ -19,3 +26,30 @@ Example:
 
 		backlight = <&backlight>;
 	};
+
+or
+        panel: panel {
+                compatible = "simple-panel";
+		enable-gpios = <&gpio 90 0>;
+
+		backlight = <&backlight>;
+
+		width = 1920;
+		height = 1080;
+		display-timings {
+	                native-mode = <&timing0>;
+			timing0: 1080p24 {
+				/* 1920x1080p24 */
+				clock-frequency = <52000000>;
+				hactive = <1920>;
+				vactive = <1080>;
+				hfront-porch = <25>;
+				hback-porch = <25>;
+				hsync-len = <25>;
+				vback-porch = <2>;
+				vfront-porch = <2>;
+				vsync-len = <2>;
+				hsync-active = <1>;
+			};
+		};
+	};
-- 
1.8.3.2


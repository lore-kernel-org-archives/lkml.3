Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681AbaCQJz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:55:59 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:47038 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210AbaCQJz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:55:57 -0400
X-Mailbox-Line: From f23ca5eb0aa076b149723b2c9cd67a840344db60 Mon Sep 17 00:00:00 2001
Message-Id: <f23ca5eb0aa076b149723b2c9cd67a840344db60.1395049204.git.moinejf@free.fr>
In-Reply-To: <cover.1395049204.git.moinejf@free.fr>
References: <cover.1395049204.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Mon, 17 Mar 2014 10:31:45 +0100
Subject: [PATCH RFC 4/5] drm/tilcd: dts: Add the video sink
To: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The connection between the video source and sink must follow
the media video interface.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 Documentation/devicetree/bindings/drm/tilcdc/slave.txt | 18 ------------------
 .../devicetree/bindings/drm/tilcdc/tilcdc.txt          |  6 ++++++
 2 files changed, 6 insertions(+), 18 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/drm/tilcdc/slave.txt

diff --git a/Documentation/devicetree/bindings/drm/tilcdc/slave.txt b/Documentation/devicetree/bindings/drm/tilcdc/slave.txt
deleted file mode 100644
index 3d2c524..0000000
--- a/Documentation/devicetree/bindings/drm/tilcdc/slave.txt
+++ /dev/null
@@ -1,18 +0,0 @@
-Device-Tree bindings for tilcdc DRM encoder slave output driver
-
-Required properties:
- - compatible: value should be "ti,tilcdc,slave".
- - i2c: the phandle for the i2c device the encoder slave is connected to
-
-Recommended properties:
- - pinctrl-names, pinctrl-0: the pincontrol settings to configure
-   muxing properly for pins that connect to TFP410 device
-
-Example:
-
-	hdmi {
-		compatible = "ti,tilcdc,slave";
-		i2c = <&i2c0>;
-		pinctrl-names = "default";
-		pinctrl-0 = <&nxp_hdmi_bonelt_pins>;
-	};
diff --git a/Documentation/devicetree/bindings/drm/tilcdc/tilcdc.txt b/Documentation/devicetree/bindings/drm/tilcdc/tilcdc.txt
index fff10da..425e288 100644
--- a/Documentation/devicetree/bindings/drm/tilcdc/tilcdc.txt
+++ b/Documentation/devicetree/bindings/drm/tilcdc/tilcdc.txt
@@ -18,6 +18,12 @@ Optional properties:
  - max-pixelclock: The maximum pixel clock that can be supported
    by the lcd controller in KHz.
 
+Optional nodes:
+
+ - port: reference of the video sink as described in media/video-interfaces.
+   This reference is required when the video sink is the TDA998x HDMI
+   transmitter.
+
 Example:
 
 	fb: fb@4830e000 {
-- 
1.9.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665AbaCQJzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:55:47 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:46268 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210AbaCQJzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:55:45 -0400
X-Mailbox-Line: From d00abf5be3ca443fa0a370f454b4ef77873e933f Mon Sep 17 00:00:00 2001
Message-Id: <d00abf5be3ca443fa0a370f454b4ef77873e933f.1395049204.git.moinejf@free.fr>
In-Reply-To: <cover.1395049204.git.moinejf@free.fr>
References: <cover.1395049204.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Mon, 17 Mar 2014 10:17:37 +0100
Subject: [PATCH RFC 3/5] drm/i2c: tda998x: Add required properties
To: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The I2C address of the HDMI subdevice is needed for the driver to be
loaded and initialized at system startup time.

The origin of the video must be indicated by a reverse phandle
according to the media video interface.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 Documentation/devicetree/bindings/drm/i2c/tda998x.txt | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
index d7df01c..c9fbb0f 100644
--- a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
+++ b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
@@ -3,6 +3,8 @@ Device-Tree bindings for the NXP TDA998x HDMI transmitter
 Required properties;
   - compatible: must be "nxp,tda998x"
 
+  - reg: must be <0x70>
+
 Optional properties:
   - interrupts: interrupt number and trigger type
 	default: polling
@@ -15,6 +17,10 @@ Optional properties:
   - video-ports: 24 bits value which defines how the video controller
 	output is wired to the TDA998x input - default: <0x230145>
 
+Required nodes:
+
+  - port: reference of the video source as described in media/video-interfaces
+
 Example:
 
 	tda998x: hdmi-encoder {
@@ -24,4 +30,10 @@ Example:
 		interrupts = <27 2>;		/* falling edge */
 		pinctrl-0 = <&pmx_camera>;
 		pinctrl-names = "default";
+
+		port {
+			tda998x_0: endpoint@0 {
+				remote-endpoint = <&lcd0_0>;
+			};
+		};
 	};
-- 
1.9.0


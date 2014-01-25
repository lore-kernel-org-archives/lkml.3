Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbaA2JZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:25:18 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:38584 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbaA2JZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:25:15 -0500
X-Mailbox-Line: From 2fbe4ac9f3f0be5b300191066408379b9565098e Mon Sep 17 00:00:00 2001
Message-Id: <2fbe4ac9f3f0be5b300191066408379b9565098e.1390986083.git.moinejf@free.fr>
In-Reply-To: <cover.1390986082.git.moinejf@free.fr>
References: <cover.1390986082.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 25 Jan 2014 18:14:37 +0100
Subject: [PATCH v5 15/23] drm/i2c: tda998x: add DT documentation
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 .../devicetree/bindings/drm/i2c/tda998x.txt        | 27 ++++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/drm/i2c/tda998x.txt

diff --git a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
new file mode 100644
index 0000000..d7df01c
--- /dev/null
+++ b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
@@ -0,0 +1,27 @@
+Device-Tree bindings for the NXP TDA998x HDMI transmitter
+
+Required properties;
+  - compatible: must be "nxp,tda998x"
+
+Optional properties:
+  - interrupts: interrupt number and trigger type
+	default: polling
+
+  - pinctrl-0: pin control group to be used for
+	screen plug/unplug interrupt.
+
+  - pinctrl-names: must contain a "default" entry.
+
+  - video-ports: 24 bits value which defines how the video controller
+	output is wired to the TDA998x input - default: <0x230145>
+
+Example:
+
+	tda998x: hdmi-encoder {
+		compatible = "nxp,tda998x";
+		reg = <0x70>;
+		interrupt-parent = <&gpio0>;
+		interrupts = <27 2>;		/* falling edge */
+		pinctrl-0 = <&pmx_camera>;
+		pinctrl-names = "default";
+	};
-- 
1.9.rc1


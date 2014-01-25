Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaAYRPk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 12:15:40 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:44892 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbaAYRPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 12:15:38 -0500
Date: Sat, 25 Jan 2014 18:14:37 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org
Subject: [PATCH v4 16/24] drm/i2c: tda998x: add DT documentation
Message-ID: <20140125181437.08ef52c5@armhf>
In-Reply-To: <cover.1390646891.git.moinejf@free.fr>
References: <cover.1390646891.git.moinejf@free.fr>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 .../devicetree/bindings/drm/i2c/tda998x.txt        | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/drm/i2c/tda998x.txt

diff --git a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
new file mode 100644
index 0000000..b91d73f
--- /dev/null
+++ b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
@@ -0,0 +1,26 @@
+Device-Tree bindings for the NXP TDA998x HDMI transmitter
+
+Required properties;
+  - compatible: must be "nxp,tda998x"
+
+Optional properties:
+  - interrupts: interrupt number - default: polling
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
1.8.5.3


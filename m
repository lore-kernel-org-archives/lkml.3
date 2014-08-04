Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751003AbaHDEsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 00:48:37 -0400
Received: from regular2.263xmail.com ([211.157.152.3]:47726 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaHDEse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 00:48:34 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: yzq@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: yzq@rock-chips.com
X-UNIQUE-TAG: <9ebc49b21ff2aa1fa445111d6d72aa65>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: mark yao <yzq@rock-chips.com>
To: heiko@sntech.de, Rob Clark <robdclark@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, David Airlie <airlied@linux.ie>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-api@vger.kernel.org, olof@lixom.net, djkurtz@chromium.org,
        xjq@rock-chips.com, kfx@rock-chips.com, cym@rock-chips.com,
        cf@rock-chips.com, zyw@rock-chips.com, zwl@rock-chips.com,
        xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com,
        zhangqing@rock-chips.com, yxj@rock-chips.com, wxt@rock-chips.com,
        xw@rock-chips.com, mark yao <yzq@rock-chips.com>
Subject: [PATCH 2/9] Add devicetree bindings for panels used by the Rockchip DRM
Date: Mon,  4 Aug 2014 12:47:00 +0800
Message-Id: <1407127620-1654-1-git-send-email-yzq@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
References: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: mark yao <yzq@rock-chips.com>
---
 .../devicetree/bindings/video/rockchip-panel.txt   |   52 ++++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/rockchip-panel.txt

diff --git a/Documentation/devicetree/bindings/video/rockchip-panel.txt b/Documentation/devicetree/bindings/video/rockchip-panel.txt
new file mode 100644
index 0000000..9fc200a
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/rockchip-panel.txt
@@ -0,0 +1,52 @@
+Rockchip LCD Display interface
+================================
+Required properties:
+-compatible: "rockchip,rockchip-panel";
+
+- rockchip,output-face: lcdc display mode value should set as following
+		"r8g8b8": 24bit display port, R8 G8 B8
+		"r6g6b6": 18bit display port, R6 G6 B6
+		"r5g6b5": 16bit display port, R5 G6 B5
+
+Optional properties:
+- display-timings: timings for the connected panel as described by
+	Documentation/devicetree/bindings/video/display-timing.txt
+Optional properties:
+- rockchip,power-gpios: gpio to power on or off the LCD (as many as needed)
+- lcdc-vcc18: Defined if power supply of lcd controller is 1.8v,
+		Not defined if power supply of lcd controller is 3.3v.
+- output-dither: support dithering the output color.
+- color-swap-rb: swap R and B color per pixel.
+- color-swap-rg: swap R and G color per pixel.
+- color-swap-bg: swap B and G color per pixel.
+
+Example:
+	panel {
+		compatible = "rockchip,rockchip-panel";
+		rockchip,output-face = "r6g6b6";
+
+		enable-gpios = <&gpio7 3 GPIO_ACTIVE_HIGH
+				&gpio7 4 GPIO_ACTIVE_HIGH>;
+		output-dither;
+
+		display-timings {
+			native-mode = <&timing_disp0>;
+
+			timing_disp0: 1280x800 {
+				clock-frequency = <71000000>;
+				hactive = <1280>;
+				vactive = <800>;
+				hback-porch = <100>;
+				hfront-porch = <18>;
+				vback-porch = <8>;
+				vfront-porch = <6>;
+				hsync-len = <10>;
+				vsync-len = <2>;
+				hsync-active = <0>;
+				vsync-active = <0>;
+				de-active = <0>;
+				pixelclk-active = <0>;
+			};
+		};
+
+	};
-- 
1.7.9.5



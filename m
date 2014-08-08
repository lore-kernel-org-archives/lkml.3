Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401AbaHHW3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:29:18 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:53896 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758343AbaHHW3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 18:29:14 -0400
From: Doug Anderson <dianders@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>, Heiko Stuebner <heiko@sntech.de>
Cc: linux-arm-kernel@lists.infradead.org, Sonny Rao <sonnyrao@chromium.org>,
        eddie.cai@rock-chips.com, Doug Anderson <dianders@chromium.org>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl: Add mux options 3 and 4 for rockchip pinctrl
Date: Fri,  8 Aug 2014 15:29:09 -0700
Message-Id: <1407536949-31323-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer Rockchip SoCs have more muxing slots.  Add slots 3 and 4 since
the rk3288 table goes all the way up to 4.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 Documentation/devicetree/bindings/pinctrl/rockchip,pinctrl.txt | 6 +++---
 include/dt-bindings/pinctrl/rockchip.h                         | 2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/rockchip,pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/rockchip,pinctrl.txt
index 4658b69..388b213 100644
--- a/Documentation/devicetree/bindings/pinctrl/rockchip,pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/rockchip,pinctrl.txt
@@ -2,8 +2,8 @@
 
 The Rockchip Pinmux Controller, enables the IC
 to share one PAD to several functional blocks. The sharing is done by
-multiplexing the PAD input/output signals. For each PAD there are up to
-4 muxing options with option 0 being the use as a GPIO.
+multiplexing the PAD input/output signals. For each PAD there are several
+muxing options with option 0 being the use as a GPIO.
 
 Please refer to pinctrl-bindings.txt in this directory for details of the
 common pinctrl bindings used by client devices, including the meaning of the
@@ -58,7 +58,7 @@ Deprecated properties for gpio sub nodes:
 Required properties for pin configuration node:
   - rockchip,pins: 3 integers array, represents a group of pins mux and config
     setting. The format is rockchip,pins = <PIN_BANK PIN_BANK_IDX MUX &phandle>.
-    The MUX 0 means gpio and MUX 1 to 3 mean the specific device function.
+    The MUX 0 means gpio and MUX 1 to N mean the specific device function.
     The phandle of a node containing the generic pinconfig options
     to use, as described in pinctrl-bindings.txt in this directory.
 
diff --git a/include/dt-bindings/pinctrl/rockchip.h b/include/dt-bindings/pinctrl/rockchip.h
index cd5788b..743e66a 100644
--- a/include/dt-bindings/pinctrl/rockchip.h
+++ b/include/dt-bindings/pinctrl/rockchip.h
@@ -28,5 +28,7 @@
 #define RK_FUNC_GPIO	0
 #define RK_FUNC_1	1
 #define RK_FUNC_2	2
+#define RK_FUNC_3	3
+#define RK_FUNC_4	4
 
 #endif
-- 
2.0.0.526.g5318336


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaFDWUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:20:53 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:40212 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaFDWUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:20:48 -0400
From: Doug Anderson <dianders@chromium.org>
To: Stephen Warren <swarren@nvidia.com>, Thierry Reding <treding@nvidia.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, olof@lixom.net
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ARM: tegra: Use the cros-ec-keyboard fragment in venice2
Date: Wed,  4 Jun 2014 15:20:19 -0700
Message-Id: <1401920421-25729-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1401920421-25729-1-git-send-email-dianders@chromium.org>
References: <1401920421-25729-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/boot/dts/tegra124-venice2.dts | 96 ++--------------------------------
 1 file changed, 3 insertions(+), 93 deletions(-)

diff --git a/arch/arm/boot/dts/tegra124-venice2.dts b/arch/arm/boot/dts/tegra124-venice2.dts
index f0bb842..72585c82 100644
--- a/arch/arm/boot/dts/tegra124-venice2.dts
+++ b/arch/arm/boot/dts/tegra124-venice2.dts
@@ -816,7 +816,7 @@
 	spi@0,7000d400 {
 		status = "okay";
 
-		cros-ec@0 {
+		cros_ec: cros-ec@0 {
 			compatible = "google,cros-ec-spi";
 			spi-max-frequency = <4000000>;
 			interrupt-parent = <&gpio>;
@@ -824,98 +824,6 @@
 			reg = <0>;
 
 			google,cros-ec-spi-msg-delay = <2000>;
-
-			cros-ec-keyb {
-				compatible = "google,cros-ec-keyb";
-				keypad,num-rows = <8>;
-				keypad,num-columns = <13>;
-				google,needs-ghost-filter;
-
-				linux,keymap = <
-					MATRIX_KEY(0x00, 0x01, KEY_LEFTMETA)
-					MATRIX_KEY(0x00, 0x02, KEY_F1)
-					MATRIX_KEY(0x00, 0x03, KEY_B)
-					MATRIX_KEY(0x00, 0x04, KEY_F10)
-					MATRIX_KEY(0x00, 0x06, KEY_N)
-					MATRIX_KEY(0x00, 0x08, KEY_EQUAL)
-					MATRIX_KEY(0x00, 0x0a, KEY_RIGHTALT)
-
-					MATRIX_KEY(0x01, 0x01, KEY_ESC)
-					MATRIX_KEY(0x01, 0x02, KEY_F4)
-					MATRIX_KEY(0x01, 0x03, KEY_G)
-					MATRIX_KEY(0x01, 0x04, KEY_F7)
-					MATRIX_KEY(0x01, 0x06, KEY_H)
-					MATRIX_KEY(0x01, 0x08, KEY_APOSTROPHE)
-					MATRIX_KEY(0x01, 0x09, KEY_F9)
-					MATRIX_KEY(0x01, 0x0b, KEY_BACKSPACE)
-
-					MATRIX_KEY(0x02, 0x00, KEY_LEFTCTRL)
-					MATRIX_KEY(0x02, 0x01, KEY_TAB)
-					MATRIX_KEY(0x02, 0x02, KEY_F3)
-					MATRIX_KEY(0x02, 0x03, KEY_T)
-					MATRIX_KEY(0x02, 0x04, KEY_F6)
-					MATRIX_KEY(0x02, 0x05, KEY_RIGHTBRACE)
-					MATRIX_KEY(0x02, 0x06, KEY_Y)
-					MATRIX_KEY(0x02, 0x07, KEY_102ND)
-					MATRIX_KEY(0x02, 0x08, KEY_LEFTBRACE)
-					MATRIX_KEY(0x02, 0x09, KEY_F8)
-
-					MATRIX_KEY(0x03, 0x01, KEY_GRAVE)
-					MATRIX_KEY(0x03, 0x02, KEY_F2)
-					MATRIX_KEY(0x03, 0x03, KEY_5)
-					MATRIX_KEY(0x03, 0x04, KEY_F5)
-					MATRIX_KEY(0x03, 0x06, KEY_6)
-					MATRIX_KEY(0x03, 0x08, KEY_MINUS)
-					MATRIX_KEY(0x03, 0x0b, KEY_BACKSLASH)
-
-					MATRIX_KEY(0x04, 0x00, KEY_RIGHTCTRL)
-					MATRIX_KEY(0x04, 0x01, KEY_A)
-					MATRIX_KEY(0x04, 0x02, KEY_D)
-					MATRIX_KEY(0x04, 0x03, KEY_F)
-					MATRIX_KEY(0x04, 0x04, KEY_S)
-					MATRIX_KEY(0x04, 0x05, KEY_K)
-					MATRIX_KEY(0x04, 0x06, KEY_J)
-					MATRIX_KEY(0x04, 0x08, KEY_SEMICOLON)
-					MATRIX_KEY(0x04, 0x09, KEY_L)
-					MATRIX_KEY(0x04, 0x0a, KEY_BACKSLASH)
-					MATRIX_KEY(0x04, 0x0b, KEY_ENTER)
-
-					MATRIX_KEY(0x05, 0x01, KEY_Z)
-					MATRIX_KEY(0x05, 0x02, KEY_C)
-					MATRIX_KEY(0x05, 0x03, KEY_V)
-					MATRIX_KEY(0x05, 0x04, KEY_X)
-					MATRIX_KEY(0x05, 0x05, KEY_COMMA)
-					MATRIX_KEY(0x05, 0x06, KEY_M)
-					MATRIX_KEY(0x05, 0x07, KEY_LEFTSHIFT)
-					MATRIX_KEY(0x05, 0x08, KEY_SLASH)
-					MATRIX_KEY(0x05, 0x09, KEY_DOT)
-					MATRIX_KEY(0x05, 0x0b, KEY_SPACE)
-
-					MATRIX_KEY(0x06, 0x01, KEY_1)
-					MATRIX_KEY(0x06, 0x02, KEY_3)
-					MATRIX_KEY(0x06, 0x03, KEY_4)
-					MATRIX_KEY(0x06, 0x04, KEY_2)
-					MATRIX_KEY(0x06, 0x05, KEY_8)
-					MATRIX_KEY(0x06, 0x06, KEY_7)
-					MATRIX_KEY(0x06, 0x08, KEY_0)
-					MATRIX_KEY(0x06, 0x09, KEY_9)
-					MATRIX_KEY(0x06, 0x0a, KEY_LEFTALT)
-					MATRIX_KEY(0x06, 0x0b, KEY_DOWN)
-					MATRIX_KEY(0x06, 0x0c, KEY_RIGHT)
-
-					MATRIX_KEY(0x07, 0x01, KEY_Q)
-					MATRIX_KEY(0x07, 0x02, KEY_E)
-					MATRIX_KEY(0x07, 0x03, KEY_R)
-					MATRIX_KEY(0x07, 0x04, KEY_W)
-					MATRIX_KEY(0x07, 0x05, KEY_I)
-					MATRIX_KEY(0x07, 0x06, KEY_U)
-					MATRIX_KEY(0x07, 0x07, KEY_RIGHTSHIFT)
-					MATRIX_KEY(0x07, 0x08, KEY_P)
-					MATRIX_KEY(0x07, 0x09, KEY_O)
-					MATRIX_KEY(0x07, 0x0b, KEY_UP)
-					MATRIX_KEY(0x07, 0x0c, KEY_LEFT)
-				>;
-			};
 		};
 	};
 
@@ -1205,3 +1113,5 @@
 		clock-names = "pll_a", "pll_a_out0", "mclk";
 	};
 };
+
+#include "cros-ec-keyboard.dtsi"
-- 
2.0.0.526.g5318336


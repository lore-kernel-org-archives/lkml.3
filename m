Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab3LBNMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:12:54 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6781 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab3LBNMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:12:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 02 Dec 2013 05:10:00 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <rob.herring@calxeda.com>, <mark.rutland@arm.com>,
        <thierry.reding@gmail.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <ijc+devicetree@hellion.org.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] ARM: tegra: convert device tree files to use key defines
Date: Mon, 2 Dec 2013 18:39:57 +0530
Message-ID: <1385989797-10879-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use key code macros for all key code refernced for keys.

For tegra20-seaboard.dts and tegra20-harmony.dts:
  The key comment for key (16th row and 1st column) is KEY_KPSLASH but
  code is 0x004e which is the key code for KEY_KPPLUS. As there other
  key exist with KY_KPPLUS, I am assuming key code is wrong and comment
  is fine. With this assumption, I am keeping the key code as KEY_KPSLASH.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra20-harmony.dts   |  221 +++++++++++++-------------
 arch/arm/boot/dts/tegra20-paz00.dts     |    3 +-
 arch/arm/boot/dts/tegra20-seaboard.dts  |  261 ++++++++++++++++---------------
 arch/arm/boot/dts/tegra20-trimslice.dts |    3 +-
 arch/arm/boot/dts/tegra20-ventana.dts   |    3 +-
 arch/arm/boot/dts/tegra20-whistler.dts  |    9 +-
 6 files changed, 253 insertions(+), 247 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-harmony.dts b/arch/arm/boot/dts/tegra20-harmony.dts
index e156ab3..8f79fc3 100644
--- a/arch/arm/boot/dts/tegra20-harmony.dts
+++ b/arch/arm/boot/dts/tegra20-harmony.dts
@@ -1,5 +1,6 @@
 /dts-v1/;
 
+#include <dt-bindings/input/input.h>
 #include "tegra20.dtsi"
 
 / {
@@ -502,7 +503,7 @@
 		power {
 			label = "Power";
 			gpios = <&gpio TEGRA_GPIO(V, 2) GPIO_ACTIVE_LOW>;
-			linux,code = <116>; /* KEY_POWER */
+			linux,code = <KEY_POWER>;
 			gpio-key,wakeup;
 		};
 	};
@@ -513,115 +514,115 @@
 		nvidia,repeat-delay-ms = <160>;
 		nvidia,kbc-row-pins = <0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15>;
 		nvidia,kbc-col-pins = <16 17 18 19 20 21 22 23>;
-		linux,keymap = <0x00020011	/* KEY_W */
-				0x0003001F	/* KEY_S */
-				0x0004001E	/* KEY_A */
-				0x0005002C	/* KEY_Z */
-				0x000701D0	/* KEY_FN */
-				0x0107008B	/* KEY_MENU */
-				0x02060038	/* KEY_LEFTALT */
-				0x02070064	/* KEY_RIGHTALT */
-				0x03000006	/* KEY_5 */
-				0x03010005	/* KEY_4 */
-				0x03020013	/* KEY_R */
-				0x03030012	/* KEY_E */
-				0x03040021	/* KEY_F */
-				0x03050020	/* KEY_D */
-				0x0306002D	/* KEY_X */
-				0x04000008	/* KEY_7 */
-				0x04010007	/* KEY_6 */
-				0x04020014	/* KEY_T */
-				0x04030023	/* KEY_H */
-				0x04040022	/* KEY_G */
-				0x0405002F	/* KEY_V */
-				0x0406002E	/* KEY_C */
-				0x04070039	/* KEY_SPACE */
-				0x0500000A	/* KEY_9 */
-				0x05010009	/* KEY_8 */
-				0x05020016	/* KEY_U */
-				0x05030015	/* KEY_Y */
-				0x05040024	/* KEY_J */
-				0x05050031	/* KEY_N */
-				0x05060030	/* KEY_B */
-				0x0507002B	/* KEY_BACKSLASH */
-				0x0600000C	/* KEY_MINUS */
-				0x0601000B	/* KEY_0 */
-				0x06020018	/* KEY_O */
-				0x06030017	/* KEY_I */
-				0x06040026	/* KEY_L */
-				0x06050025	/* KEY_K */
-				0x06060033	/* KEY_COMMA */
-				0x06070032	/* KEY_M */
-				0x0701000D	/* KEY_EQUAL */
-				0x0702001B	/* KEY_RIGHTBRACE */
-				0x0703001C	/* KEY_ENTER */
-				0x0707008B	/* KEY_MENU */
-				0x0804002A	/* KEY_LEFTSHIFT */
-				0x08050036	/* KEY_RIGHTSHIFT */
-				0x0905001D	/* KEY_LEFTCTRL */
-				0x09070061	/* KEY_RIGHTCTRL */
-				0x0B00001A	/* KEY_LEFTBRACE */
-				0x0B010019	/* KEY_P */
-				0x0B020028	/* KEY_APOSTROPHE */
-				0x0B030027	/* KEY_SEMICOLON */
-				0x0B040035	/* KEY_SLASH */
-				0x0B050034	/* KEY_DOT */
-				0x0C000044	/* KEY_F10 */
-				0x0C010043	/* KEY_F9 */
-				0x0C02000E	/* KEY_BACKSPACE */
-				0x0C030004	/* KEY_3 */
-				0x0C040003	/* KEY_2 */
-				0x0C050067	/* KEY_UP */
-				0x0C0600D2	/* KEY_PRINT */
-				0x0C070077	/* KEY_PAUSE */
-				0x0D00006E	/* KEY_INSERT */
-				0x0D01006F	/* KEY_DELETE */
-				0x0D030068	/* KEY_PAGEUP */
-				0x0D04006D	/* KEY_PAGEDOWN */
-				0x0D05006A	/* KEY_RIGHT */
-				0x0D06006C	/* KEY_DOWN */
-				0x0D070069	/* KEY_LEFT */
-				0x0E000057	/* KEY_F11 */
-				0x0E010058	/* KEY_F12 */
-				0x0E020042	/* KEY_F8 */
-				0x0E030010	/* KEY_Q */
-				0x0E04003E	/* KEY_F4 */
-				0x0E05003D	/* KEY_F3 */
-				0x0E060002	/* KEY_1 */
-				0x0E070041	/* KEY_F7 */
-				0x0F000001	/* KEY_ESC */
-				0x0F010029	/* KEY_GRAVE */
-				0x0F02003F	/* KEY_F5 */
-				0x0F03000F	/* KEY_TAB */
-				0x0F04003B	/* KEY_F1 */
-				0x0F05003C	/* KEY_F2 */
-				0x0F06003A	/* KEY_CAPSLOCK */
-				0x0F070040	/* KEY_F6 */
-				0x14000047	/* KEY_KP7 */
-				0x15000049	/* KEY_KP9 */
-				0x15010048	/* KEY_KP8 */
-				0x1502004B	/* KEY_KP4 */
-				0x1504004F	/* KEY_KP1 */
-				0x1601004E	/* KEY_KPSLASH */
-				0x1602004D	/* KEY_KP6 */
-				0x1603004C	/* KEY_KP5 */
-				0x16040051	/* KEY_KP3 */
-				0x16050050	/* KEY_KP2 */
-				0x16070052	/* KEY_KP0 */
-				0x1B010037	/* KEY_KPASTERISK */
-				0x1B03004A	/* KEY_KPMINUS */
-				0x1B04004E	/* KEY_KPPLUS */
-				0x1B050053	/* KEY_KPDOT */
-				0x1C050073	/* KEY_VOLUMEUP */
-				0x1D030066	/* KEY_HOME */
-				0x1D04006B	/* KEY_END */
-				0x1D0500E1	/* KEY_BRIGHTNESSUP */
-				0x1D060072	/* KEY_VOLUMEDOWN */
-				0x1D0700E0	/* KEY_BRIGHTNESSDOWN */
-				0x1E000045	/* KEY_NUMLOCK */
-				0x1E010046	/* KEY_SCROLLLOCK */
-				0x1E020071	/* KEY_MUTE */
-				0x1F0400D6>;	/* KEY_QUESTION */
+		linux,keymap = <MATRIX_KEY(0x00, 0x02, KEY_W)
+				MATRIX_KEY(0x00, 0x03, KEY_S)
+				MATRIX_KEY(0x00, 0x04, KEY_A)
+				MATRIX_KEY(0x00, 0x05, KEY_Z)
+				MATRIX_KEY(0x00, 0x07, KEY_FN)
+				MATRIX_KEY(0x01, 0x07, KEY_MENU)
+				MATRIX_KEY(0x02, 0x06, KEY_LEFTALT)
+				MATRIX_KEY(0x02, 0x07, KEY_RIGHTALT)
+				MATRIX_KEY(0x03, 0x00, KEY_5)
+				MATRIX_KEY(0x03, 0x01, KEY_4)
+				MATRIX_KEY(0x03, 0x02, KEY_R)
+				MATRIX_KEY(0x03, 0x03, KEY_E)
+				MATRIX_KEY(0x03, 0x04, KEY_F)
+				MATRIX_KEY(0x03, 0x05, KEY_D)
+				MATRIX_KEY(0x03, 0x06, KEY_X)
+				MATRIX_KEY(0x04, 0x00, KEY_7)
+				MATRIX_KEY(0x04, 0x01, KEY_6)
+				MATRIX_KEY(0x04, 0x02, KEY_T)
+				MATRIX_KEY(0x04, 0x03, KEY_H)
+				MATRIX_KEY(0x04, 0x04, KEY_G)
+				MATRIX_KEY(0x04, 0x05, KEY_V)
+				MATRIX_KEY(0x04, 0x06, KEY_C)
+				MATRIX_KEY(0x04, 0x07, KEY_SPACE)
+				MATRIX_KEY(0x05, 0x00, KEY_9)
+				MATRIX_KEY(0x05, 0x01, KEY_8)
+				MATRIX_KEY(0x05, 0x02, KEY_U)
+				MATRIX_KEY(0x05, 0x03, KEY_Y)
+				MATRIX_KEY(0x05, 0x04, KEY_J)
+				MATRIX_KEY(0x05, 0x05, KEY_N)
+				MATRIX_KEY(0x05, 0x06, KEY_B)
+				MATRIX_KEY(0x05, 0x07, KEY_BACKSLASH)
+				MATRIX_KEY(0x06, 0x00, KEY_MINUS)
+				MATRIX_KEY(0x06, 0x01, KEY_0)
+				MATRIX_KEY(0x06, 0x02, KEY_O)
+				MATRIX_KEY(0x06, 0x03, KEY_I)
+				MATRIX_KEY(0x06, 0x04, KEY_L)
+				MATRIX_KEY(0x06, 0x05, KEY_K)
+				MATRIX_KEY(0x06, 0x06, KEY_COMMA)
+				MATRIX_KEY(0x06, 0x07, KEY_M)
+				MATRIX_KEY(0x07, 0x01, KEY_EQUAL)
+				MATRIX_KEY(0x07, 0x02, KEY_RIGHTBRACE)
+				MATRIX_KEY(0x07, 0x03, KEY_ENTER)
+				MATRIX_KEY(0x07, 0x07, KEY_MENU)
+				MATRIX_KEY(0x08, 0x04, KEY_LEFTSHIFT)
+				MATRIX_KEY(0x08, 0x05, KEY_RIGHTSHIFT)
+				MATRIX_KEY(0x09, 0x05, KEY_LEFTCTRL)
+				MATRIX_KEY(0x09, 0x07, KEY_RIGHTCTRL)
+				MATRIX_KEY(0x0B, 0x00, KEY_LEFTBRACE)
+				MATRIX_KEY(0x0B, 0x01, KEY_P)
+				MATRIX_KEY(0x0B, 0x02, KEY_APOSTROPHE)
+				MATRIX_KEY(0x0B, 0x03, KEY_SEMICOLON)
+				MATRIX_KEY(0x0B, 0x04, KEY_SLASH)
+				MATRIX_KEY(0x0B, 0x05, KEY_DOT)
+				MATRIX_KEY(0x0C, 0x00, KEY_F10)
+				MATRIX_KEY(0x0C, 0x01, KEY_F9)
+				MATRIX_KEY(0x0C, 0x02, KEY_BACKSPACE)
+				MATRIX_KEY(0x0C, 0x03, KEY_3)
+				MATRIX_KEY(0x0C, 0x04, KEY_2)
+				MATRIX_KEY(0x0C, 0x05, KEY_UP)
+				MATRIX_KEY(0x0C, 0x06, KEY_PRINT)
+				MATRIX_KEY(0x0C, 0x07, KEY_PAUSE)
+				MATRIX_KEY(0x0D, 0x00, KEY_INSERT)
+				MATRIX_KEY(0x0D, 0x01, KEY_DELETE)
+				MATRIX_KEY(0x0D, 0x03, KEY_PAGEUP )
+				MATRIX_KEY(0x0D, 0x04, KEY_PAGEDOWN)
+				MATRIX_KEY(0x0D, 0x05, KEY_RIGHT)
+				MATRIX_KEY(0x0D, 0x06, KEY_DOWN)
+				MATRIX_KEY(0x0D, 0x07, KEY_LEFT)
+				MATRIX_KEY(0x0E, 0x00, KEY_F11)
+				MATRIX_KEY(0x0E, 0x01, KEY_F12)
+				MATRIX_KEY(0x0E, 0x02, KEY_F8)
+				MATRIX_KEY(0x0E, 0x03, KEY_Q)
+				MATRIX_KEY(0x0E, 0x04, KEY_F4)
+				MATRIX_KEY(0x0E, 0x05, KEY_F3)
+				MATRIX_KEY(0x0E, 0x06, KEY_1)
+				MATRIX_KEY(0x0E, 0x07, KEY_F7)
+				MATRIX_KEY(0x0F, 0x00, KEY_ESC)
+				MATRIX_KEY(0x0F, 0x01, KEY_GRAVE)
+				MATRIX_KEY(0x0F, 0x02, KEY_F5)
+				MATRIX_KEY(0x0F, 0x03, KEY_TAB)
+				MATRIX_KEY(0x0F, 0x04, KEY_F1)
+				MATRIX_KEY(0x0F, 0x05, KEY_F2)
+				MATRIX_KEY(0x0F, 0x06, KEY_CAPSLOCK)
+				MATRIX_KEY(0x0F, 0x07, KEY_F6)
+				MATRIX_KEY(0x14, 0x00, KEY_KP7)
+				MATRIX_KEY(0x15, 0x00, KEY_KP9)
+				MATRIX_KEY(0x15, 0x01, KEY_KP8)
+				MATRIX_KEY(0x15, 0x02, KEY_KP4)
+				MATRIX_KEY(0x15, 0x04, KEY_KP1)
+				MATRIX_KEY(0x16, 0x01, KEY_KPSLASH)
+				MATRIX_KEY(0x16, 0x02, KEY_KP6)
+				MATRIX_KEY(0x16, 0x03, KEY_KP5)
+				MATRIX_KEY(0x16, 0x04, KEY_KP3)
+				MATRIX_KEY(0x16, 0x05, KEY_KP2)
+				MATRIX_KEY(0x16, 0x07, KEY_KP0)
+				MATRIX_KEY(0x1B, 0x01, KEY_KPASTERISK)
+				MATRIX_KEY(0x1B, 0x03, KEY_KPMINUS)
+				MATRIX_KEY(0x1B, 0x04, KEY_KPPLUS)
+				MATRIX_KEY(0x1B, 0x05, KEY_KPDOT)
+				MATRIX_KEY(0x1C, 0x05, KEY_VOLUMEUP)
+				MATRIX_KEY(0x1D, 0x03, KEY_HOME)
+				MATRIX_KEY(0x1D, 0x04, KEY_END)
+				MATRIX_KEY(0x1D, 0x05, KEY_BRIGHTNESSUP)
+				MATRIX_KEY(0x1D, 0x06, KEY_VOLUMEDOWN)
+				MATRIX_KEY(0x1D, 0x07, KEY_BRIGHTNESSDOWN)
+				MATRIX_KEY(0x1E, 0x00, KEY_NUMLOCK)
+				MATRIX_KEY(0x1E, 0x01, KEY_SCROLLLOCK)
+				MATRIX_KEY(0x1E, 0x02, KEY_MUTE)
+				MATRIX_KEY(0x1F, 0x04, KEY_QUESTION)>;
 	};
 
 	regulators {
diff --git a/arch/arm/boot/dts/tegra20-paz00.dts b/arch/arm/boot/dts/tegra20-paz00.dts
index 8d71fc9..70e5b5c 100644
--- a/arch/arm/boot/dts/tegra20-paz00.dts
+++ b/arch/arm/boot/dts/tegra20-paz00.dts
@@ -1,5 +1,6 @@
 /dts-v1/;
 
+#include <dt-bindings/input/input.h>
 #include "tegra20.dtsi"
 
 / {
@@ -486,7 +487,7 @@
 		power {
 			label = "Power";
 			gpios = <&gpio TEGRA_GPIO(J, 7) GPIO_ACTIVE_LOW>;
-			linux,code = <116>; /* KEY_POWER */
+			linux,code = <KEY_POWER>;
 			gpio-key,wakeup;
 		};
 	};
diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts b/arch/arm/boot/dts/tegra20-seaboard.dts
index 315aae2..19f3c46 100644
--- a/arch/arm/boot/dts/tegra20-seaboard.dts
+++ b/arch/arm/boot/dts/tegra20-seaboard.dts
@@ -1,5 +1,6 @@
 /dts-v1/;
 
+#include <dt-bindings/input/input.h>
 #include "tegra20.dtsi"
 
 / {
@@ -635,7 +636,7 @@
 		power {
 			label = "Power";
 			gpios = <&gpio TEGRA_GPIO(V, 2) GPIO_ACTIVE_LOW>;
-			linux,code = <116>; /* KEY_POWER */
+			linux,code = <KEY_POWER>;
 			gpio-key,wakeup;
 		};
 
@@ -656,137 +657,137 @@
 		nvidia,ghost-filter;
 		nvidia,kbc-row-pins = <0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15>;
 		nvidia,kbc-col-pins = <16 17 18 19 20 21 22 23>;
-		linux,keymap = <0x00020011	/* KEY_W */
-				0x0003001F	/* KEY_S */
-				0x0004001E	/* KEY_A */
-				0x0005002C	/* KEY_Z */
-				0x000701d0	/* KEY_FN */
-
-				0x0107007D	/* KEY_LEFTMETA */
-				0x02060064 	/* KEY_RIGHTALT */
-				0x02070038	/* KEY_LEFTALT */
-
-				0x03000006	/* KEY_5 */
-				0x03010005	/* KEY_4 */
-				0x03020013	/* KEY_R */
-				0x03030012	/* KEY_E */
-				0x03040021	/* KEY_F */
-				0x03050020	/* KEY_D */
-				0x0306002D	/* KEY_X */
-
-				0x04000008	/* KEY_7 */
-				0x04010007	/* KEY_6 */
-				0x04020014	/* KEY_T */
-				0x04030023	/* KEY_H */
-				0x04040022	/* KEY_G */
-				0x0405002F	/* KEY_V */
-				0x0406002E	/* KEY_C */
-				0x04070039	/* KEY_SPACE */
-
-				0x0500000A	/* KEY_9 */
-				0x05010009	/* KEY_8 */
-				0x05020016	/* KEY_U */
-				0x05030015	/* KEY_Y */
-				0x05040024	/* KEY_J */
-				0x05050031	/* KEY_N */
-				0x05060030	/* KEY_B */
-				0x0507002B	/* KEY_BACKSLASH */
-
-				0x0600000C	/* KEY_MINUS */
-				0x0601000B	/* KEY_0 */
-				0x06020018	/* KEY_O */
-				0x06030017	/* KEY_I */
-				0x06040026	/* KEY_L */
-				0x06050025	/* KEY_K */
-				0x06060033	/* KEY_COMMA */
-				0x06070032	/* KEY_M */
-
-				0x0701000D	/* KEY_EQUAL */
-				0x0702001B	/* KEY_RIGHTBRACE */
-				0x0703001C	/* KEY_ENTER */
-				0x0707008B	/* KEY_MENU */
-
-				0x08040036	/* KEY_RIGHTSHIFT */
-				0x0805002A	/* KEY_LEFTSHIFT */
-
-				0x09050061	/* KEY_RIGHTCTRL */
-				0x0907001D	/* KEY_LEFTCTRL */
-
-				0x0B00001A	/* KEY_LEFTBRACE */
-				0x0B010019	/* KEY_P */
-				0x0B020028	/* KEY_APOSTROPHE */
-				0x0B030027	/* KEY_SEMICOLON */
-				0x0B040035	/* KEY_SLASH */
-				0x0B050034	/* KEY_DOT */
-
-				0x0C000044	/* KEY_F10 */
-				0x0C010043	/* KEY_F9 */
-				0x0C02000E	/* KEY_BACKSPACE */
-				0x0C030004	/* KEY_3 */
-				0x0C040003	/* KEY_2 */
-				0x0C050067	/* KEY_UP */
-				0x0C0600D2	/* KEY_PRINT */
-				0x0C070077	/* KEY_PAUSE */
-
-				0x0D00006E	/* KEY_INSERT */
-				0x0D01006F	/* KEY_DELETE */
-				0x0D030068	/* KEY_PAGEUP  */
-				0x0D04006D	/* KEY_PAGEDOWN */
-				0x0D05006A	/* KEY_RIGHT */
-				0x0D06006C	/* KEY_DOWN */
-				0x0D070069	/* KEY_LEFT */
-
-				0x0E000057	/* KEY_F11 */
-				0x0E010058	/* KEY_F12 */
-				0x0E020042	/* KEY_F8 */
-				0x0E030010	/* KEY_Q */
-				0x0E04003E	/* KEY_F4 */
-				0x0E05003D	/* KEY_F3 */
-				0x0E060002	/* KEY_1 */
-				0x0E070041	/* KEY_F7 */
-
-				0x0F000001	/* KEY_ESC */
-				0x0F010029	/* KEY_GRAVE */
-				0x0F02003F	/* KEY_F5 */
-				0x0F03000F	/* KEY_TAB */
-				0x0F04003B	/* KEY_F1 */
-				0x0F05003C	/* KEY_F2 */
-				0x0F06003A	/* KEY_CAPSLOCK */
-				0x0F070040	/* KEY_F6 */
+		linux,keymap = <MATRIX_KEY(0x00, 0x02, KEY_W)
+				MATRIX_KEY(0x00, 0x03, KEY_S)
+				MATRIX_KEY(0x00, 0x04, KEY_A)
+				MATRIX_KEY(0x00, 0x05, KEY_Z)
+				MATRIX_KEY(0x00, 0x07, KEY_FN)
+
+				MATRIX_KEY(0x01, 0x07, KEY_LEFTMETA)
+				MATRIX_KEY(0x02, 0x06, KEY_RIGHTALT)
+				MATRIX_KEY(0x02, 0x07, KEY_LEFTALT)
+
+				MATRIX_KEY(0x03, 0x00, KEY_5)
+				MATRIX_KEY(0x03, 0x01, KEY_4)
+				MATRIX_KEY(0x03, 0x02, KEY_R)
+				MATRIX_KEY(0x03, 0x03, KEY_E)
+				MATRIX_KEY(0x03, 0x04, KEY_F)
+				MATRIX_KEY(0x03, 0x05, KEY_D)
+				MATRIX_KEY(0x03, 0x06, KEY_X)
+
+				MATRIX_KEY(0x04, 0x00, KEY_7)
+				MATRIX_KEY(0x04, 0x01, KEY_6)
+				MATRIX_KEY(0x04, 0x02, KEY_T)
+				MATRIX_KEY(0x04, 0x03, KEY_H)
+				MATRIX_KEY(0x04, 0x04, KEY_G)
+				MATRIX_KEY(0x04, 0x05, KEY_V)
+				MATRIX_KEY(0x04, 0x06, KEY_C)
+				MATRIX_KEY(0x04, 0x07, KEY_SPACE)
+
+				MATRIX_KEY(0x05, 0x00, KEY_9)
+				MATRIX_KEY(0x05, 0x01, KEY_8)
+				MATRIX_KEY(0x05, 0x02, KEY_U)
+				MATRIX_KEY(0x05, 0x03, KEY_Y)
+				MATRIX_KEY(0x05, 0x04, KEY_J)
+				MATRIX_KEY(0x05, 0x05, KEY_N)
+				MATRIX_KEY(0x05, 0x06, KEY_B)
+				MATRIX_KEY(0x05, 0x07, KEY_BACKSLASH)
+
+				MATRIX_KEY(0x06, 0x00, KEY_MINUS)
+				MATRIX_KEY(0x06, 0x01, KEY_0)
+				MATRIX_KEY(0x06, 0x02, KEY_O)
+				MATRIX_KEY(0x06, 0x03, KEY_I)
+				MATRIX_KEY(0x06, 0x04, KEY_L)
+				MATRIX_KEY(0x06, 0x05, KEY_K)
+				MATRIX_KEY(0x06, 0x06, KEY_COMMA)
+				MATRIX_KEY(0x06, 0x07, KEY_M)
+
+				MATRIX_KEY(0x07, 0x01, KEY_EQUAL)
+				MATRIX_KEY(0x07, 0x02, KEY_RIGHTBRACE)
+				MATRIX_KEY(0x07, 0x03, KEY_ENTER)
+				MATRIX_KEY(0x07, 0x07, KEY_MENU)
+
+				MATRIX_KEY(0x08, 0x04, KEY_RIGHTSHIFT)
+				MATRIX_KEY(0x08, 0x05, KEY_LEFTSHIFT)
+
+				MATRIX_KEY(0x09, 0x05, KEY_RIGHTCTRL)
+				MATRIX_KEY(0x09, 0x07, KEY_LEFTCTRL)
+
+				MATRIX_KEY(0x0B, 0x00, KEY_LEFTBRACE)
+				MATRIX_KEY(0x0B, 0x01, KEY_P)
+				MATRIX_KEY(0x0B, 0x02, KEY_APOSTROPHE)
+				MATRIX_KEY(0x0B, 0x03, KEY_SEMICOLON)
+				MATRIX_KEY(0x0B, 0x04, KEY_SLASH)
+				MATRIX_KEY(0x0B, 0x05, KEY_DOT)
+
+				MATRIX_KEY(0x0C, 0x00, KEY_F10)
+				MATRIX_KEY(0x0C, 0x01, KEY_F9)
+				MATRIX_KEY(0x0C, 0x02, KEY_BACKSPACE)
+				MATRIX_KEY(0x0C, 0x03, KEY_3)
+				MATRIX_KEY(0x0C, 0x04, KEY_2)
+				MATRIX_KEY(0x0C, 0x05, KEY_UP)
+				MATRIX_KEY(0x0C, 0x06, KEY_PRINT)
+				MATRIX_KEY(0x0C, 0x07, KEY_PAUSE)
+
+				MATRIX_KEY(0x0D, 0x00, KEY_INSERT)
+				MATRIX_KEY(0x0D, 0x01, KEY_DELETE)
+				MATRIX_KEY(0x0D, 0x03, KEY_PAGEUP )
+				MATRIX_KEY(0x0D, 0x04, KEY_PAGEDOWN)
+				MATRIX_KEY(0x0D, 0x05, KEY_RIGHT)
+				MATRIX_KEY(0x0D, 0x06, KEY_DOWN)
+				MATRIX_KEY(0x0D, 0x07, KEY_LEFT)
+
+				MATRIX_KEY(0x0E, 0x00, KEY_F11)
+				MATRIX_KEY(0x0E, 0x01, KEY_F12)
+				MATRIX_KEY(0x0E, 0x02, KEY_F8)
+				MATRIX_KEY(0x0E, 0x03, KEY_Q)
+				MATRIX_KEY(0x0E, 0x04, KEY_F4)
+				MATRIX_KEY(0x0E, 0x05, KEY_F3)
+				MATRIX_KEY(0x0E, 0x06, KEY_1)
+				MATRIX_KEY(0x0E, 0x07, KEY_F7)
+
+				MATRIX_KEY(0x0F, 0x00, KEY_ESC)
+				MATRIX_KEY(0x0F, 0x01, KEY_GRAVE)
+				MATRIX_KEY(0x0F, 0x02, KEY_F5)
+				MATRIX_KEY(0x0F, 0x03, KEY_TAB)
+				MATRIX_KEY(0x0F, 0x04, KEY_F1)
+				MATRIX_KEY(0x0F, 0x05, KEY_F2)
+				MATRIX_KEY(0x0F, 0x06, KEY_CAPSLOCK)
+				MATRIX_KEY(0x0F, 0x07, KEY_F6)
 
 				/* Software Handled Function Keys */
-				0x14000047	/* KEY_KP7 */
-
-				0x15000049	/* KEY_KP9 */
-				0x15010048	/* KEY_KP8 */
-				0x1502004B	/* KEY_KP4 */
-				0x1504004F	/* KEY_KP1 */
-
-				0x1601004E	/* KEY_KPSLASH */
-				0x1602004D	/* KEY_KP6 */
-				0x1603004C	/* KEY_KP5 */
-				0x16040051	/* KEY_KP3 */
-				0x16050050	/* KEY_KP2 */
-				0x16070052	/* KEY_KP0 */
-
-				0x1B010037	/* KEY_KPASTERISK */
-				0x1B03004A	/* KEY_KPMINUS */
-				0x1B04004E	/* KEY_KPPLUS */
-				0x1B050053	/* KEY_KPDOT */
-
-				0x1C050073	/* KEY_VOLUMEUP */
-
-				0x1D030066	/* KEY_HOME */
-				0x1D04006B	/* KEY_END */
-				0x1D0500E0	/* KEY_BRIGHTNESSDOWN */
-				0x1D060072	/* KEY_VOLUMEDOWN */
-				0x1D0700E1	/* KEY_BRIGHTNESSUP */
-
-				0x1E000045	/* KEY_NUMLOCK */
-				0x1E010046	/* KEY_SCROLLLOCK */
-				0x1E020071	/* KEY_MUTE */
-
-				0x1F04008A>;	/* KEY_HELP */
+				MATRIX_KEY(0x14, 0x00, KEY_KP7)
+
+				MATRIX_KEY(0x15, 0x00, KEY_KP9)
+				MATRIX_KEY(0x15, 0x01, KEY_KP8)
+				MATRIX_KEY(0x15, 0x02, KEY_KP4)
+				MATRIX_KEY(0x15, 0x04, KEY_KP1)
+
+				MATRIX_KEY(0x16, 0x01, KEY_KPSLASH)
+				MATRIX_KEY(0x16, 0x02, KEY_KP6)
+				MATRIX_KEY(0x16, 0x03, KEY_KP5)
+				MATRIX_KEY(0x16, 0x04, KEY_KP3)
+				MATRIX_KEY(0x16, 0x05, KEY_KP2)
+				MATRIX_KEY(0x16, 0x07, KEY_KP0)
+
+				MATRIX_KEY(0x1B, 0x01, KEY_KPASTERISK)
+				MATRIX_KEY(0x1B, 0x03, KEY_KPMINUS)
+				MATRIX_KEY(0x1B, 0x04, KEY_KPPLUS)
+				MATRIX_KEY(0x1B, 0x05, KEY_KPDOT)
+
+				MATRIX_KEY(0x1C, 0x05, KEY_VOLUMEUP)
+
+				MATRIX_KEY(0x1D, 0x03, KEY_HOME)
+				MATRIX_KEY(0x1D, 0x04, KEY_END)
+				MATRIX_KEY(0x1D, 0x05, KEY_BRIGHTNESSDOWN)
+				MATRIX_KEY(0x1D, 0x06, KEY_VOLUMEDOWN)
+				MATRIX_KEY(0x1D, 0x07, KEY_BRIGHTNESSUP)
+
+				MATRIX_KEY(0x1E, 0x00, KEY_NUMLOCK)
+				MATRIX_KEY(0x1E, 0x01, KEY_SCROLLLOCK)
+				MATRIX_KEY(0x1E, 0x02, KEY_MUTE)
+
+				MATRIX_KEY(0x1F, 0x04, KEY_HELP)>;
 	};
 	regulators {
 		compatible = "simple-bus";
diff --git a/arch/arm/boot/dts/tegra20-trimslice.dts b/arch/arm/boot/dts/tegra20-trimslice.dts
index 78deea5..8afdb23 100644
--- a/arch/arm/boot/dts/tegra20-trimslice.dts
+++ b/arch/arm/boot/dts/tegra20-trimslice.dts
@@ -1,5 +1,6 @@
 /dts-v1/;
 
+#include <dt-bindings/input/input.h>
 #include "tegra20.dtsi"
 
 / {
@@ -380,7 +381,7 @@
 		power {
 			label = "Power";
 			gpios = <&gpio TEGRA_GPIO(X, 6) GPIO_ACTIVE_LOW>;
-			linux,code = <116>; /* KEY_POWER */
+			linux,code = <KEY_POWER>;
 			gpio-key,wakeup;
 		};
 	};
diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index aab872c..24665ee 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -1,5 +1,6 @@
 /dts-v1/;
 
+#include <dt-bindings/input/input.h>
 #include "tegra20.dtsi"
 
 / {
@@ -570,7 +571,7 @@
 		power {
 			label = "Power";
 			gpios = <&gpio TEGRA_GPIO(V, 2) GPIO_ACTIVE_LOW>;
-			linux,code = <116>; /* KEY_POWER */
+			linux,code = <KEY_POWER>;
 			gpio-key,wakeup;
 		};
 	};
diff --git a/arch/arm/boot/dts/tegra20-whistler.dts b/arch/arm/boot/dts/tegra20-whistler.dts
index d33a73c..56420dd 100644
--- a/arch/arm/boot/dts/tegra20-whistler.dts
+++ b/arch/arm/boot/dts/tegra20-whistler.dts
@@ -1,5 +1,6 @@
 /dts-v1/;
 
+#include <dt-bindings/input/input.h>
 #include "tegra20.dtsi"
 
 / {
@@ -558,10 +559,10 @@
 		nvidia,kbc-row-pins = <0 1 2>;
 		nvidia,kbc-col-pins = <16 17>;
 		nvidia,wakeup-source;
-		linux,keymap = <0x00000074	/* KEY_POWER */
-				0x01000066	/* KEY_HOME */
-				0x0101009E	/* KEY_BACK */
-				0x0201008B>;	/* KEY_MENU */
+		linux,keymap = <MATRIX_KEY(0x00, 0x00, KEY_POWER)
+				MATRIX_KEY(0x01, 0x00, KEY_HOME)
+				MATRIX_KEY(0x01, 0x01, KEY_BACK)
+				MATRIX_KEY(0x02, 0x01, KEY_MENU)>;
 	};
 
 	regulators {
-- 
1.7.1.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab3FRD6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 23:58:53 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:54525 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180Ab3FRD6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 23:58:52 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <dmitry.torokhov@gmail.com>, <arnd@arndb.de>, <eric.y.miao@gmail.com>,
        <haojian.zhuang@gmail.com>, <drwyrm@gmail.com>, <stefan@openezx.org>,
        <laforge@openezx.org>, <robert.jarzmik@free.fr>,
        <marek.vasut@gmail.com>, <sleep_walker@suse.cz>, <slapin@ossfans.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V3 3/5] arm: pxa: use matrix_keymap for all boards
Date: Mon, 17 Jun 2013 23:56:16 -0400
Message-ID: <1371527778-5236-4-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371527778-5236-1-git-send-email-chao.xie@marvell.com>
References: <1371527778-5236-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile passed for configurations

em_x270_defconfig
  em_x270x.c(MACH_EM_X270, MACH_EXEDA)

ezx_defconfig
  ezx.c(MACH_EZX_A780, MACH_EZX_E680, MACH_EZX_A1200,
        MACH_EZX_A910, MACH_EZX_E6, MACH_EZX_E2)

palmz72_defconfig
  palmld.c(MACH_PALMLD), palmtreo.c(PALM_TREO),
  palmtx.c(MACH_PALMTX), palmz72.c(MACH_PALMZ72),
  palmt5.c(MACH_PALMT5)

pxa3xx_defconfig
  littleton.c(MACH_LITTLETON), tarvorevb.c(MACH_TAVOREVB),
  zylonite.c(MACH_ZYLONITE320), mioa701.c(MACH_MIOA701),
  z2.c(MACH_ZIPIT2)

mainstone_defconfig
  maintone.c(MACH_MAINSTONE)

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 arch/arm/mach-pxa/em-x270.c   |   20 +++++++++----
 arch/arm/mach-pxa/ezx.c       |   60 ++++++++++++++++++++++++++++------------
 arch/arm/mach-pxa/littleton.c |   10 +++++--
 arch/arm/mach-pxa/mainstone.c |   10 +++++--
 arch/arm/mach-pxa/mioa701.c   |   11 +++++--
 arch/arm/mach-pxa/palmld.c    |   10 +++++--
 arch/arm/mach-pxa/palmt5.c    |   10 +++++--
 arch/arm/mach-pxa/palmtreo.c  |   23 ++++++++++-----
 arch/arm/mach-pxa/palmtx.c    |   10 +++++--
 arch/arm/mach-pxa/palmz72.c   |   10 +++++--
 arch/arm/mach-pxa/tavorevb.c  |   10 +++++--
 arch/arm/mach-pxa/z2.c        |   10 +++++--
 arch/arm/mach-pxa/zylonite.c  |   10 +++++--
 13 files changed, 142 insertions(+), 62 deletions(-)

diff --git a/arch/arm/mach-pxa/em-x270.c b/arch/arm/mach-pxa/em-x270.c
index 446563a..f6726bb 100644
--- a/arch/arm/mach-pxa/em-x270.c
+++ b/arch/arm/mach-pxa/em-x270.c
@@ -833,21 +833,25 @@ static inline void em_x270_init_ac97(void) {}
 #endif
 
 #if defined(CONFIG_KEYBOARD_PXA27x) || defined(CONFIG_KEYBOARD_PXA27x_MODULE)
-static unsigned int em_x270_module_matrix_keys[] = {
+static const unsigned int em_x270_module_matrix_keys[] = {
 	KEY(0, 0, KEY_A), KEY(1, 0, KEY_UP), KEY(2, 1, KEY_B),
 	KEY(0, 2, KEY_LEFT), KEY(1, 1, KEY_ENTER), KEY(2, 0, KEY_RIGHT),
 	KEY(0, 1, KEY_C), KEY(1, 2, KEY_DOWN), KEY(2, 2, KEY_D),
 };
 
+static struct matrix_keymap_data em_x270_matrix_keymap_data = {
+	.keymap			= em_x270_module_matrix_keys,
+	.keymap_size		= ARRAY_SIZE(em_x270_module_matrix_keys),
+};
+
 struct pxa27x_keypad_platform_data em_x270_module_keypad_info = {
 	/* code map for the matrix keys */
 	.matrix_key_rows	= 3,
 	.matrix_key_cols	= 3,
-	.matrix_key_map		= em_x270_module_matrix_keys,
-	.matrix_key_map_size	= ARRAY_SIZE(em_x270_module_matrix_keys),
+	.matrix_keymap_data	= &em_x270_matrix_keymap_data,
 };
 
-static unsigned int em_x270_exeda_matrix_keys[] = {
+static const unsigned int em_x270_exeda_matrix_keys[] = {
 	KEY(0, 0, KEY_RIGHTSHIFT), KEY(0, 1, KEY_RIGHTCTRL),
 	KEY(0, 2, KEY_RIGHTALT), KEY(0, 3, KEY_SPACE),
 	KEY(0, 4, KEY_LEFTALT), KEY(0, 5, KEY_LEFTCTRL),
@@ -889,12 +893,16 @@ static unsigned int em_x270_exeda_matrix_keys[] = {
 	KEY(7, 6, 0), KEY(7, 7, 0),
 };
 
+static struct matrix_keymap_data em_x270_exeda_matrix_keymap_data = {
+	.keymap			= em_x270_exeda_matrix_keys,
+	.keymap_size		= ARRAY_SIZE(em_x270_exeda_matrix_keys),
+};
+
 struct pxa27x_keypad_platform_data em_x270_exeda_keypad_info = {
 	/* code map for the matrix keys */
 	.matrix_key_rows	= 8,
 	.matrix_key_cols	= 8,
-	.matrix_key_map		= em_x270_exeda_matrix_keys,
-	.matrix_key_map_size	= ARRAY_SIZE(em_x270_exeda_matrix_keys),
+	.matrix_keymap_data	= &em_x270_exeda_matrix_keymap_data,
 };
 
 static void __init em_x270_init_keypad(void)
diff --git a/arch/arm/mach-pxa/ezx.c b/arch/arm/mach-pxa/ezx.c
index dca1070..fe2eb83 100644
--- a/arch/arm/mach-pxa/ezx.c
+++ b/arch/arm/mach-pxa/ezx.c
@@ -392,7 +392,7 @@ static unsigned long e6_pin_config[] __initdata = {
 
 /* KEYPAD */
 #ifdef CONFIG_MACH_EZX_A780
-static unsigned int a780_key_map[] = {
+static const unsigned int a780_key_map[] = {
 	KEY(0, 0, KEY_SEND),
 	KEY(0, 1, KEY_BACK),
 	KEY(0, 2, KEY_END),
@@ -424,11 +424,15 @@ static unsigned int a780_key_map[] = {
 	KEY(4, 4, KEY_DOWN),
 };
 
+static struct matrix_keymap_data a780_matrix_keymap_data = {
+	.keymap			= a780_key_map,
+	.keymap_size		= ARRAY_SIZE(a780_key_map),
+};
+
 static struct pxa27x_keypad_platform_data a780_keypad_platform_data = {
 	.matrix_key_rows = 5,
 	.matrix_key_cols = 5,
-	.matrix_key_map = a780_key_map,
-	.matrix_key_map_size = ARRAY_SIZE(a780_key_map),
+	.matrix_keymap_data = &a780_matrix_keymap_data,
 
 	.direct_key_map = { KEY_CAMERA },
 	.direct_key_num = 1,
@@ -438,7 +442,7 @@ static struct pxa27x_keypad_platform_data a780_keypad_platform_data = {
 #endif /* CONFIG_MACH_EZX_A780 */
 
 #ifdef CONFIG_MACH_EZX_E680
-static unsigned int e680_key_map[] = {
+static const unsigned int e680_key_map[] = {
 	KEY(0, 0, KEY_UP),
 	KEY(0, 1, KEY_RIGHT),
 	KEY(0, 2, KEY_RESERVED),
@@ -455,11 +459,15 @@ static unsigned int e680_key_map[] = {
 	KEY(2, 3, KEY_KPENTER),
 };
 
+static struct matrix_keymap_data e680_matrix_keymap_data = {
+	.keymap			= e680_key_map,
+	.keymap_size		= ARRAY_SIZE(e680_key_map),
+};
+
 static struct pxa27x_keypad_platform_data e680_keypad_platform_data = {
 	.matrix_key_rows = 3,
 	.matrix_key_cols = 4,
-	.matrix_key_map = e680_key_map,
-	.matrix_key_map_size = ARRAY_SIZE(e680_key_map),
+	.matrix_keymap_data = &e680_matrix_keymap_data,
 
 	.direct_key_map = {
 		KEY_CAMERA,
@@ -476,7 +484,7 @@ static struct pxa27x_keypad_platform_data e680_keypad_platform_data = {
 #endif /* CONFIG_MACH_EZX_E680 */
 
 #ifdef CONFIG_MACH_EZX_A1200
-static unsigned int a1200_key_map[] = {
+static const unsigned int a1200_key_map[] = {
 	KEY(0, 0, KEY_RESERVED),
 	KEY(0, 1, KEY_RIGHT),
 	KEY(0, 2, KEY_PAGEDOWN),
@@ -513,18 +521,22 @@ static unsigned int a1200_key_map[] = {
 	KEY(4, 5, KEY_RESERVED),
 };
 
+static struct matrix_keymap_data a1200_matrix_keymap_data = {
+	.keymap			= a1200_key_map,
+	.keymap_size		= ARRAY_SIZE(a1200_key_map),
+};
+
 static struct pxa27x_keypad_platform_data a1200_keypad_platform_data = {
 	.matrix_key_rows = 5,
 	.matrix_key_cols = 6,
-	.matrix_key_map = a1200_key_map,
-	.matrix_key_map_size = ARRAY_SIZE(a1200_key_map),
+	.matrix_keymap_data = &a1200_matrix_keymap_data,
 
 	.debounce_interval = 30,
 };
 #endif /* CONFIG_MACH_EZX_A1200 */
 
 #ifdef CONFIG_MACH_EZX_E6
-static unsigned int e6_key_map[] = {
+static const unsigned int e6_key_map[] = {
 	KEY(0, 0, KEY_RESERVED),
 	KEY(0, 1, KEY_RIGHT),
 	KEY(0, 2, KEY_PAGEDOWN),
@@ -561,18 +573,22 @@ static unsigned int e6_key_map[] = {
 	KEY(4, 5, KEY_PREVIOUSSONG),
 };
 
+static struct matrix_keymap_data e6_keymap_data = {
+	.keymap			= e6_key_map,
+	.keymap_size		= ARRAY_SIZE(e6_key_map),
+};
+
 static struct pxa27x_keypad_platform_data e6_keypad_platform_data = {
 	.matrix_key_rows = 5,
 	.matrix_key_cols = 6,
-	.matrix_key_map = e6_key_map,
-	.matrix_key_map_size = ARRAY_SIZE(e6_key_map),
+	.matrix_keymap_data = &e6_keymap_data,
 
 	.debounce_interval = 30,
 };
 #endif /* CONFIG_MACH_EZX_E6 */
 
 #ifdef CONFIG_MACH_EZX_A910
-static unsigned int a910_key_map[] = {
+static const unsigned int a910_key_map[] = {
 	KEY(0, 0, KEY_NUMERIC_6),
 	KEY(0, 1, KEY_RIGHT),
 	KEY(0, 2, KEY_PAGEDOWN),
@@ -609,18 +625,22 @@ static unsigned int a910_key_map[] = {
 	KEY(4, 5, KEY_RESERVED),
 };
 
+static struct matrix_keymap_data a910_matrix_keymap_data = {
+	.keymap			= a910_key_map,
+	.keymap_size		= ARRAY_SIZE(a910_key_map),
+};
+
 static struct pxa27x_keypad_platform_data a910_keypad_platform_data = {
 	.matrix_key_rows = 5,
 	.matrix_key_cols = 6,
-	.matrix_key_map = a910_key_map,
-	.matrix_key_map_size = ARRAY_SIZE(a910_key_map),
+	.matrix_keymap_data = &a910_matrix_keymap_data,
 
 	.debounce_interval = 30,
 };
 #endif /* CONFIG_MACH_EZX_A910 */
 
 #ifdef CONFIG_MACH_EZX_E2
-static unsigned int e2_key_map[] = {
+static const unsigned int e2_key_map[] = {
 	KEY(0, 0, KEY_NUMERIC_6),
 	KEY(0, 1, KEY_RIGHT),
 	KEY(0, 2, KEY_NUMERIC_9),
@@ -657,11 +677,15 @@ static unsigned int e2_key_map[] = {
 	KEY(4, 5, KEY_RESERVED),
 };
 
+static struct matrix_keymap_data e2_matrix_keymap_data = {
+	.keymap			= e2_key_map,
+	.keymap_size		= ARRAY_SIZE(e2_key_map),
+};
+
 static struct pxa27x_keypad_platform_data e2_keypad_platform_data = {
 	.matrix_key_rows = 5,
 	.matrix_key_cols = 6,
-	.matrix_key_map = e2_key_map,
-	.matrix_key_map_size = ARRAY_SIZE(e2_key_map),
+	.matrix_keymap_data = &e2_matrix_keymap_data,
 
 	.debounce_interval = 30,
 };
diff --git a/arch/arm/mach-pxa/littleton.c b/arch/arm/mach-pxa/littleton.c
index e848c46..5d66558 100644
--- a/arch/arm/mach-pxa/littleton.c
+++ b/arch/arm/mach-pxa/littleton.c
@@ -222,7 +222,7 @@ static inline void littleton_init_spi(void) {}
 #endif
 
 #if defined(CONFIG_KEYBOARD_PXA27x) || defined(CONFIG_KEYBOARD_PXA27x_MODULE)
-static unsigned int littleton_matrix_key_map[] = {
+static const unsigned int littleton_matrix_key_map[] = {
 	/* KEY(row, col, key_code) */
 	KEY(1, 3, KEY_0), KEY(0, 0, KEY_1), KEY(1, 0, KEY_2), KEY(2, 0, KEY_3),
 	KEY(0, 1, KEY_4), KEY(1, 1, KEY_5), KEY(2, 1, KEY_6), KEY(0, 2, KEY_7),
@@ -249,11 +249,15 @@ static unsigned int littleton_matrix_key_map[] = {
 	KEY(3, 1, KEY_F23),	/* soft2 */
 };
 
+static struct matrix_keymap_data littleton_matrix_keymap_data = {
+	.keymap			= littleton_matrix_key_map,
+	.keymap_size		= ARRAY_SIZE(littleton_matrix_key_map),
+};
+
 static struct pxa27x_keypad_platform_data littleton_keypad_info = {
 	.matrix_key_rows	= 6,
 	.matrix_key_cols	= 5,
-	.matrix_key_map		= littleton_matrix_key_map,
-	.matrix_key_map_size	= ARRAY_SIZE(littleton_matrix_key_map),
+	.matrix_keymap_data	= &littleton_matrix_keymap_data,
 
 	.enable_rotary0		= 1,
 	.rotary0_up_key		= KEY_UP,
diff --git a/arch/arm/mach-pxa/mainstone.c b/arch/arm/mach-pxa/mainstone.c
index 7a12c1b..d2c6523 100644
--- a/arch/arm/mach-pxa/mainstone.c
+++ b/arch/arm/mach-pxa/mainstone.c
@@ -498,7 +498,7 @@ static struct pxaohci_platform_data mainstone_ohci_platform_data = {
 };
 
 #if defined(CONFIG_KEYBOARD_PXA27x) || defined(CONFIG_KEYBOARD_PXA27x_MODULE)
-static unsigned int mainstone_matrix_keys[] = {
+static const unsigned int mainstone_matrix_keys[] = {
 	KEY(0, 0, KEY_A), KEY(1, 0, KEY_B), KEY(2, 0, KEY_C),
 	KEY(3, 0, KEY_D), KEY(4, 0, KEY_E), KEY(5, 0, KEY_F),
 	KEY(0, 1, KEY_G), KEY(1, 1, KEY_H), KEY(2, 1, KEY_I),
@@ -527,11 +527,15 @@ static unsigned int mainstone_matrix_keys[] = {
 	KEY(4, 6, KEY_SELECT),
 };
 
+static struct matrix_keymap_data mainstone_matrix_keymap_data = {
+	.keymap			= mainstone_matrix_keys,
+	.keymap_size		= ARRAY_SIZE(mainstone_matrix_keys),
+};
+
 struct pxa27x_keypad_platform_data mainstone_keypad_info = {
 	.matrix_key_rows	= 6,
 	.matrix_key_cols	= 7,
-	.matrix_key_map		= mainstone_matrix_keys,
-	.matrix_key_map_size	= ARRAY_SIZE(mainstone_matrix_keys),
+	.matrix_keymap_data	= &mainstone_matrix_keymap_data,
 
 	.enable_rotary0		= 1,
 	.rotary0_up_key		= KEY_UP,
diff --git a/arch/arm/mach-pxa/mioa701.c b/arch/arm/mach-pxa/mioa701.c
index f8979b9..654b0ac 100644
--- a/arch/arm/mach-pxa/mioa701.c
+++ b/arch/arm/mach-pxa/mioa701.c
@@ -222,7 +222,7 @@ static struct pxafb_mach_info mioa701_pxafb_info = {
 /*
  * Keyboard configuration
  */
-static unsigned int mioa701_matrix_keys[] = {
+static const unsigned int mioa701_matrix_keys[] = {
 	KEY(0, 0, KEY_UP),
 	KEY(0, 1, KEY_RIGHT),
 	KEY(0, 2, KEY_MEDIA),
@@ -233,11 +233,16 @@ static unsigned int mioa701_matrix_keys[] = {
 	KEY(2, 1, KEY_PHONE),	/* Phone Green key */
 	KEY(2, 2, KEY_CAMERA)	/* Camera key */
 };
+
+static struct matrix_keymap_data mioa701_matrix_keymap_data = {
+	.keymap			= mioa701_matrix_keys,
+	.keymap_size		= ARRAY_SIZE(mioa701_matrix_keys),
+};
+
 static struct pxa27x_keypad_platform_data mioa701_keypad_info = {
 	.matrix_key_rows = 3,
 	.matrix_key_cols = 3,
-	.matrix_key_map = mioa701_matrix_keys,
-	.matrix_key_map_size = ARRAY_SIZE(mioa701_matrix_keys),
+	.matrix_keymap_data = &mioa701_matrix_keymap_data,
 };
 
 /*
diff --git a/arch/arm/mach-pxa/palmld.c b/arch/arm/mach-pxa/palmld.c
index 909b713..cf210b1 100644
--- a/arch/arm/mach-pxa/palmld.c
+++ b/arch/arm/mach-pxa/palmld.c
@@ -173,7 +173,7 @@ static inline void palmld_nor_init(void) {}
  * GPIO keyboard
  ******************************************************************************/
 #if defined(CONFIG_KEYBOARD_PXA27x) || defined(CONFIG_KEYBOARD_PXA27x_MODULE)
-static unsigned int palmld_matrix_keys[] = {
+static const unsigned int palmld_matrix_keys[] = {
 	KEY(0, 1, KEY_F2),
 	KEY(0, 2, KEY_UP),
 
@@ -190,11 +190,15 @@ static unsigned int palmld_matrix_keys[] = {
 	KEY(3, 2, KEY_LEFT),
 };
 
+static struct matrix_keymap_data palmld_matrix_keymap_data = {
+	.keymap			= palmld_matrix_keys,
+	.keymap_size		= ARRAY_SIZE(palmld_matrix_keys),
+};
+
 static struct pxa27x_keypad_platform_data palmld_keypad_platform_data = {
 	.matrix_key_rows	= 4,
 	.matrix_key_cols	= 3,
-	.matrix_key_map		= palmld_matrix_keys,
-	.matrix_key_map_size	= ARRAY_SIZE(palmld_matrix_keys),
+	.matrix_keymap_data	= &palmld_matrix_keymap_data,
 
 	.debounce_interval	= 30,
 };
diff --git a/arch/arm/mach-pxa/palmt5.c b/arch/arm/mach-pxa/palmt5.c
index 5033fd0..3ed9b02 100644
--- a/arch/arm/mach-pxa/palmt5.c
+++ b/arch/arm/mach-pxa/palmt5.c
@@ -108,7 +108,7 @@ static unsigned long palmt5_pin_config[] __initdata = {
  * GPIO keyboard
  ******************************************************************************/
 #if defined(CONFIG_KEYBOARD_PXA27x) || defined(CONFIG_KEYBOARD_PXA27x_MODULE)
-static unsigned int palmt5_matrix_keys[] = {
+static const unsigned int palmt5_matrix_keys[] = {
 	KEY(0, 0, KEY_POWER),
 	KEY(0, 1, KEY_F1),
 	KEY(0, 2, KEY_ENTER),
@@ -124,11 +124,15 @@ static unsigned int palmt5_matrix_keys[] = {
 	KEY(3, 2, KEY_LEFT),
 };
 
+static struct matrix_keymap_data palmt5_matrix_keymap_data = {
+	.keymap			= palmt5_matrix_keys,
+	.keymap_size		= ARRAY_SIZE(palmt5_matrix_keys),
+};
+
 static struct pxa27x_keypad_platform_data palmt5_keypad_platform_data = {
 	.matrix_key_rows	= 4,
 	.matrix_key_cols	= 3,
-	.matrix_key_map		= palmt5_matrix_keys,
-	.matrix_key_map_size	= ARRAY_SIZE(palmt5_matrix_keys),
+	.matrix_keymap_data	= &palmt5_matrix_keymap_data,
 
 	.debounce_interval	= 30,
 };
diff --git a/arch/arm/mach-pxa/palmtreo.c b/arch/arm/mach-pxa/palmtreo.c
index d82a50b..d8b937c 100644
--- a/arch/arm/mach-pxa/palmtreo.c
+++ b/arch/arm/mach-pxa/palmtreo.c
@@ -168,7 +168,7 @@ static unsigned long centro685_pin_config[] __initdata = {
  * GPIO keyboard
  ******************************************************************************/
 #if IS_ENABLED(CONFIG_KEYBOARD_PXA27x)
-static unsigned int treo680_matrix_keys[] = {
+static const unsigned int treo680_matrix_keys[] = {
 	KEY(0, 0, KEY_F8),		/* Red/Off/Power */
 	KEY(0, 1, KEY_LEFT),
 	KEY(0, 2, KEY_LEFTCTRL),	/* Alternate */
@@ -227,7 +227,7 @@ static unsigned int treo680_matrix_keys[] = {
 	KEY(7, 5, KEY_I),
 };
 
-static unsigned int centro_matrix_keys[] = {
+static const unsigned int centro_matrix_keys[] = {
 	KEY(0, 0, KEY_F9),		/* Home */
 	KEY(0, 1, KEY_LEFT),
 	KEY(0, 2, KEY_LEFTCTRL),	/* Alternate */
@@ -286,11 +286,20 @@ static unsigned int centro_matrix_keys[] = {
 	KEY(7, 5, KEY_I),
 };
 
+static struct matrix_keymap_data treo680_matrix_keymap_data = {
+	.keymap			= treo680_matrix_keys,
+	.keymap_size		= ARRAY_SIZE(treo680_matrix_keys),
+};
+
+static struct matrix_keymap_data centro_matrix_keymap_data = {
+	.keymap			= centro_matrix_keys,
+	.keymap_size		= ARRAY_SIZE(centro_matrix_keys),
+};
+
 static struct pxa27x_keypad_platform_data treo680_keypad_pdata = {
 	.matrix_key_rows	= 8,
 	.matrix_key_cols	= 7,
-	.matrix_key_map		= treo680_matrix_keys,
-	.matrix_key_map_size	= ARRAY_SIZE(treo680_matrix_keys),
+	.matrix_keymap_data	= &treo680_matrix_keymap_data,
 	.direct_key_map		= { KEY_CONNECT },
 	.direct_key_num		= 1,
 
@@ -301,10 +310,8 @@ static void __init palmtreo_kpc_init(void)
 {
 	static struct pxa27x_keypad_platform_data *data = &treo680_keypad_pdata;
 
-	if (machine_is_centro()) {
-		data->matrix_key_map = centro_matrix_keys;
-		data->matrix_key_map_size = ARRAY_SIZE(centro_matrix_keys);
-	}
+	if (machine_is_centro())
+		data->matrix_keymap_data = &centro_matrix_keymap_data;
 
 	pxa_set_keypad_info(&treo680_keypad_pdata);
 }
diff --git a/arch/arm/mach-pxa/palmtx.c b/arch/arm/mach-pxa/palmtx.c
index 627c93a..83f830d 100644
--- a/arch/arm/mach-pxa/palmtx.c
+++ b/arch/arm/mach-pxa/palmtx.c
@@ -176,7 +176,7 @@ static inline void palmtx_nor_init(void) {}
  * GPIO keyboard
  ******************************************************************************/
 #if defined(CONFIG_KEYBOARD_PXA27x) || defined(CONFIG_KEYBOARD_PXA27x_MODULE)
-static unsigned int palmtx_matrix_keys[] = {
+static const unsigned int palmtx_matrix_keys[] = {
 	KEY(0, 0, KEY_POWER),
 	KEY(0, 1, KEY_F1),
 	KEY(0, 2, KEY_ENTER),
@@ -192,11 +192,15 @@ static unsigned int palmtx_matrix_keys[] = {
 	KEY(3, 2, KEY_LEFT),
 };
 
+static struct matrix_keymap_data palmtx_matrix_keymap_data = {
+	.keymap			= palmtx_matrix_keys,
+	.keymap_size		= ARRAY_SIZE(palmtx_matrix_keys),
+};
+
 static struct pxa27x_keypad_platform_data palmtx_keypad_platform_data = {
 	.matrix_key_rows	= 4,
 	.matrix_key_cols	= 3,
-	.matrix_key_map		= palmtx_matrix_keys,
-	.matrix_key_map_size	= ARRAY_SIZE(palmtx_matrix_keys),
+	.matrix_keymap_data	= &palmtx_matrix_keymap_data,
 
 	.debounce_interval	= 30,
 };
diff --git a/arch/arm/mach-pxa/palmz72.c b/arch/arm/mach-pxa/palmz72.c
index 18b7fcd..1a35ddf 100644
--- a/arch/arm/mach-pxa/palmz72.c
+++ b/arch/arm/mach-pxa/palmz72.c
@@ -140,7 +140,7 @@ static unsigned long palmz72_pin_config[] __initdata = {
  * GPIO keyboard
  ******************************************************************************/
 #if defined(CONFIG_KEYBOARD_PXA27x) || defined(CONFIG_KEYBOARD_PXA27x_MODULE)
-static unsigned int palmz72_matrix_keys[] = {
+static const unsigned int palmz72_matrix_keys[] = {
 	KEY(0, 0, KEY_POWER),
 	KEY(0, 1, KEY_F1),
 	KEY(0, 2, KEY_ENTER),
@@ -156,11 +156,15 @@ static unsigned int palmz72_matrix_keys[] = {
 	KEY(3, 2, KEY_LEFT),
 };
 
+static struct matrix_keymap_data almz72_matrix_keymap_data = {
+	.keymap			= palmz72_matrix_keys,
+	.keymap_size		= ARRAY_SIZE(palmz72_matrix_keys),
+};
+
 static struct pxa27x_keypad_platform_data palmz72_keypad_platform_data = {
 	.matrix_key_rows	= 4,
 	.matrix_key_cols	= 3,
-	.matrix_key_map		= palmz72_matrix_keys,
-	.matrix_key_map_size	= ARRAY_SIZE(palmz72_matrix_keys),
+	.matrix_keymap_data	= &almz72_matrix_keymap_data,
 
 	.debounce_interval	= 30,
 };
diff --git a/arch/arm/mach-pxa/tavorevb.c b/arch/arm/mach-pxa/tavorevb.c
index f55979c..4680efe 100644
--- a/arch/arm/mach-pxa/tavorevb.c
+++ b/arch/arm/mach-pxa/tavorevb.c
@@ -106,7 +106,7 @@ static struct platform_device smc91x_device = {
 };
 
 #if defined(CONFIG_KEYBOARD_PXA27x) || defined(CONFIG_KEYBOARD_PXA27x_MODULE)
-static unsigned int tavorevb_matrix_key_map[] = {
+static const unsigned int tavorevb_matrix_key_map[] = {
 	/* KEY(row, col, key_code) */
 	KEY(0, 4, KEY_A), KEY(0, 5, KEY_B), KEY(0, 6, KEY_C),
 	KEY(1, 4, KEY_E), KEY(1, 5, KEY_F), KEY(1, 6, KEY_G),
@@ -147,11 +147,15 @@ static unsigned int tavorevb_matrix_key_map[] = {
 	KEY(3, 3, KEY_F23),	/* soft2 */
 };
 
+static struct matrix_keymap_data tavorevb_matrix_keymap_data = {
+	.keymap		= tavorevb_matrix_key_map,
+	.keymap_size	= ARRAY_SIZE(tavorevb_matrix_key_map),
+};
+
 static struct pxa27x_keypad_platform_data tavorevb_keypad_info = {
 	.matrix_key_rows	= 7,
 	.matrix_key_cols	= 7,
-	.matrix_key_map		= tavorevb_matrix_key_map,
-	.matrix_key_map_size	= ARRAY_SIZE(tavorevb_matrix_key_map),
+	.matrix_keymap_data	= &tavorevb_matrix_keymap_data,
 	.debounce_interval	= 30,
 };
 
diff --git a/arch/arm/mach-pxa/z2.c b/arch/arm/mach-pxa/z2.c
index 989903a..2513d8f 100644
--- a/arch/arm/mach-pxa/z2.c
+++ b/arch/arm/mach-pxa/z2.c
@@ -345,7 +345,7 @@ static inline void z2_leds_init(void) {}
  * GPIO keyboard
  ******************************************************************************/
 #if defined(CONFIG_KEYBOARD_PXA27x) || defined(CONFIG_KEYBOARD_PXA27x_MODULE)
-static unsigned int z2_matrix_keys[] = {
+static const unsigned int z2_matrix_keys[] = {
 	KEY(0, 0, KEY_OPTION),
 	KEY(1, 0, KEY_UP),
 	KEY(2, 0, KEY_DOWN),
@@ -405,11 +405,15 @@ static unsigned int z2_matrix_keys[] = {
 	KEY(5, 7, KEY_DOT),
 };
 
+static struct matrix_keymap_data z2_matrix_keymap_data = {
+	.keymap			= z2_matrix_keys,
+	.keymap_size		= ARRAY_SIZE(z2_matrix_keys),
+};
+
 static struct pxa27x_keypad_platform_data z2_keypad_platform_data = {
 	.matrix_key_rows	= 7,
 	.matrix_key_cols	= 8,
-	.matrix_key_map		= z2_matrix_keys,
-	.matrix_key_map_size	= ARRAY_SIZE(z2_matrix_keys),
+	.matrix_keymap_data	= &z2_matrix_keymap_data,
 
 	.debounce_interval	= 30,
 };
diff --git a/arch/arm/mach-pxa/zylonite.c b/arch/arm/mach-pxa/zylonite.c
index 1f00d65..36cf7cf 100644
--- a/arch/arm/mach-pxa/zylonite.c
+++ b/arch/arm/mach-pxa/zylonite.c
@@ -263,7 +263,7 @@ static inline void zylonite_init_mmc(void) {}
 #endif
 
 #if defined(CONFIG_KEYBOARD_PXA27x) || defined(CONFIG_KEYBOARD_PXA27x_MODULE)
-static unsigned int zylonite_matrix_key_map[] = {
+static const unsigned int zylonite_matrix_key_map[] = {
 	/* KEY(row, col, key_code) */
 	KEY(0, 0, KEY_A), KEY(0, 1, KEY_B), KEY(0, 2, KEY_C), KEY(0, 5, KEY_D),
 	KEY(1, 0, KEY_E), KEY(1, 1, KEY_F), KEY(1, 2, KEY_G), KEY(1, 5, KEY_H),
@@ -306,11 +306,15 @@ static unsigned int zylonite_matrix_key_map[] = {
 	KEY(0, 3, KEY_AUX),	/* contact */
 };
 
+static struct matrix_keymap_data zylonite_matrix_keymap_data = {
+	.keymap			= zylonite_matrix_key_map,
+	.keymap_size		= ARRAY_SIZE(zylonite_matrix_key_map),
+};
+
 static struct pxa27x_keypad_platform_data zylonite_keypad_info = {
 	.matrix_key_rows	= 8,
 	.matrix_key_cols	= 8,
-	.matrix_key_map		= zylonite_matrix_key_map,
-	.matrix_key_map_size	= ARRAY_SIZE(zylonite_matrix_key_map),
+	.matrix_keymap_data	= &zylonite_matrix_keymap_data,
 
 	.enable_rotary0		= 1,
 	.rotary0_up_key		= KEY_UP,
-- 
1.7.4.1


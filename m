Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223Ab3FREEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 00:04:22 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:37481 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750823Ab3FREEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 00:04:20 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <dmitry.torokhov@gmail.com>, <arnd@arndb.de>, <eric.y.miao@gmail.com>,
        <haojian.zhuang@gmail.com>, <drwyrm@gmail.com>, <stefan@openezx.org>,
        <laforge@openezx.org>, <robert.jarzmik@free.fr>,
        <marek.vasut@gmail.com>, <sleep_walker@suse.cz>, <slapin@ossfans.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V3 2/5] arm: mmp: use matrix_keymap for all boards
Date: Mon, 17 Jun 2013 23:56:15 -0400
Message-ID: <1371527778-5236-3-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371527778-5236-1-git-send-email-chao.xie@marvell.com>
References: <1371527778-5236-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile passed for the configuration

pxa168_defconfig
  aspenite.c(MACH_ASPENITE), teton_bgs.c(MACH_TENTON_BGA)

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 arch/arm/mach-mmp/aspenite.c  |   10 +++++++---
 arch/arm/mach-mmp/teton_bga.c |   10 +++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-mmp/aspenite.c b/arch/arm/mach-mmp/aspenite.c
index 9f64d56..1e23346 100644
--- a/arch/arm/mach-mmp/aspenite.c
+++ b/arch/arm/mach-mmp/aspenite.c
@@ -205,7 +205,7 @@ struct pxa168fb_mach_info aspenite_lcd_info = {
 	.invert_pixclock	= 0,
 };
 
-static unsigned int aspenite_matrix_key_map[] = {
+static const unsigned int aspenite_matrix_key_map[] = {
 	KEY(0, 6, KEY_UP),	/* SW 4 */
 	KEY(0, 7, KEY_DOWN),	/* SW 5 */
 	KEY(1, 6, KEY_LEFT),	/* SW 6 */
@@ -214,11 +214,15 @@ static unsigned int aspenite_matrix_key_map[] = {
 	KEY(4, 7, KEY_ESC),	/* SW 9 */
 };
 
+static struct matrix_keymap_data aspenite_matrix_keymap_data = {
+	.keymap			= aspenite_matrix_key_map,
+	.keymap_size		= ARRAY_SIZE(aspenite_matrix_key_map),
+};
+
 static struct pxa27x_keypad_platform_data aspenite_keypad_info __initdata = {
 	.matrix_key_rows	= 5,
 	.matrix_key_cols	= 8,
-	.matrix_key_map		= aspenite_matrix_key_map,
-	.matrix_key_map_size	= ARRAY_SIZE(aspenite_matrix_key_map),
+	.matrix_keymap_data	= &aspenite_matrix_keymap_data,
 	.debounce_interval	= 30,
 };
 
diff --git a/arch/arm/mach-mmp/teton_bga.c b/arch/arm/mach-mmp/teton_bga.c
index 8609967..2021769 100644
--- a/arch/arm/mach-mmp/teton_bga.c
+++ b/arch/arm/mach-mmp/teton_bga.c
@@ -49,18 +49,22 @@ static unsigned long teton_bga_pin_config[] __initdata = {
 	GPIO78_GPIO,
 };
 
-static unsigned int teton_bga_matrix_key_map[] = {
+static const unsigned int teton_bga_matrix_key_map[] = {
 	KEY(0, 6, KEY_ESC),
 	KEY(0, 7, KEY_ENTER),
 	KEY(1, 6, KEY_LEFT),
 	KEY(1, 7, KEY_RIGHT),
 };
 
+static struct matrix_keymap_data teton_bga_matrix_keymap_data = {
+	.keymap			= teton_bga_matrix_key_map,
+	.keymap_size		= ARRAY_SIZE(teton_bga_matrix_key_map),
+};
+
 static struct pxa27x_keypad_platform_data teton_bga_keypad_info __initdata = {
 	.matrix_key_rows        = 2,
 	.matrix_key_cols        = 8,
-	.matrix_key_map         = teton_bga_matrix_key_map,
-	.matrix_key_map_size    = ARRAY_SIZE(teton_bga_matrix_key_map),
+	.matrix_keymap_data	= &teton_bga_matrix_keymap_data,
 	.debounce_interval      = 30,
 };
 
-- 
1.7.4.1


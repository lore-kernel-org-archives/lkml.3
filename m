Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaD0Bb2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 21:31:28 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.93]:39013 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbaD0BaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 21:30:07 -0400
From: Peter Feuerer <peter@piie.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Feuerer <peter@piie.net>, Andreas Mohr <andi@lisas.de>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 2/4] acerhdf: Adding support for new models
Date: Sun, 27 Apr 2014 03:23:33 +0200
Message-Id: <1398561815-22033-3-git-send-email-peter@piie.net>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398561815-22033-1-git-send-email-peter@piie.net>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
X-Df-Sender: cGV0ZXJAcGlpZS5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Feuerer <peter@piie.net>

added following new models:
   * Aspire 5755G
   * AO521
   * AO751h
   * Aspire One 753
   * Extensa 5420
   * Aspire 5315
   * Aspire 5739G
   * TravelMate TM8573T

Cc: Andreas Mohr <andi@lisas.de>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Peter Feuerer <peter@piie.net>
---
 drivers/platform/x86/acerhdf.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index eb9c94f..8b6466b 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -50,7 +50,7 @@
  */
 #undef START_IN_KERNEL_MODE
 
-#define DRV_VER "0.5.29"
+#define DRV_VER "0.5.30"
 
 /*
  * According to the Atom N270 datasheet,
@@ -194,17 +194,33 @@ static const struct bios_settings_t bios_tbl[] = {
 	{"Acer", "Aspire 1810T",  "v1.3310", 0x55, 0x58, {0x9e, 0x00}, {0, 0, 0} },
 	{"Acer", "Aspire 1810TZ", "v1.3314", 0x55, 0x58, {0x9e, 0x00}, {0, 0, 0} },
 	{"Acer", "Aspire 1810T",  "v1.3314", 0x55, 0x58, {0x9e, 0x00}, {0, 0, 0} },
+	/* Acer 5755G */
+	{"Acer", "Aspire 5755G",  "V1.20",   0xab, 0xb4, {0x00, 0x08}, {0, 0, 0} },
+	{"Acer", "Aspire 5755G",  "V1.21",   0xab, 0xb3, {0x00, 0x08}, {0, 0, 0} },
+	/* Acer 521 */
+	{"Acer", "AO521", "V1.11", 0x55, 0x58, {0x1f, 0x00}, {0, 0, 0} },
 	/* Acer 531 */
 	{"Acer", "AO531h", "v0.3104", 0x55, 0x58, {0x20, 0x00}, {0, 0, 0} },
 	{"Acer", "AO531h", "v0.3201", 0x55, 0x58, {0x20, 0x00}, {0, 0, 0} },
 	{"Acer", "AO531h", "v0.3304", 0x55, 0x58, {0x20, 0x00}, {0, 0, 0} },
 	/* Acer 751 */
+	{"Acer", "AO751h", "V0.3206", 0x55, 0x58, {0x21, 0x00}, {0, 0, 0} },
 	{"Acer", "AO751h", "V0.3212", 0x55, 0x58, {0x21, 0x00}, {0, 0, 0} },
+	/* Acer 753 */
+	{"Acer", "Aspire One 753", "V1.24", 0x93, 0xac, {0x14, 0x04}, {1, 0x94, 0xff} },
 	/* Acer 1825 */
 	{"Acer", "Aspire 1825PTZ", "V1.3118", 0x55, 0x58, {0x9e, 0x00}, {0, 0, 0} },
 	{"Acer", "Aspire 1825PTZ", "V1.3127", 0x55, 0x58, {0x9e, 0x00}, {0, 0, 0} },
+	/* Acer Extensa 5420 */
+	{"Acer", "Extensa 5420", "V1.17", 0x93, 0xac, {0x14, 0x04}, {1, 0x94, 0xff} },
+	/* Acer Aspire 5315 */
+	{"Acer", "Aspire 5315", "V1.19", 0x93, 0xac, {0x14, 0x04}, {1, 0x94, 0xff} },
+	/* Acer Aspire 5739 */
+	{"Acer", "Aspire 5739G", "V1.3311", 0x55, 0x58, {0x20, 0x00}, {0, 0, 0} },
 	/* Acer TravelMate 7730 */
 	{"Acer", "TravelMate 7730G", "v0.3509", 0x55, 0x58, {0xaf, 0x00}, {0, 0, 0} },
+	/* Acer TravelMate TM8573T */
+	{"Acer", "TM8573T", "V1.13", 0x93, 0xa8, {0x14, 0x04}, {1, 0x94, 0xff} },
 	/* Gateway */
 	{"Gateway", "AOA110", "v0.3103",  0x55, 0x58, {0x21, 0x00}, {0, 0, 0} },
 	{"Gateway", "AOA150", "v0.3103",  0x55, 0x58, {0x20, 0x00}, {0, 0, 0} },
@@ -736,9 +752,14 @@ MODULE_ALIAS("dmi:*:*Acer*:pnAOA*:");
 MODULE_ALIAS("dmi:*:*Acer*:pnAO751h*:");
 MODULE_ALIAS("dmi:*:*Acer*:pnAspire*1410*:");
 MODULE_ALIAS("dmi:*:*Acer*:pnAspire*1810*:");
+MODULE_ALIAS("dmi:*:*Acer*:pnAspire*5755G:");
 MODULE_ALIAS("dmi:*:*Acer*:pnAspire*1825PTZ:");
+MODULE_ALIAS("dmi:*:*Acer*:pnAO521*:");
 MODULE_ALIAS("dmi:*:*Acer*:pnAO531*:");
+MODULE_ALIAS("dmi:*:*Acer*:pnAspire*5739G:");
+MODULE_ALIAS("dmi:*:*Acer*:pnAspire*5315:");
 MODULE_ALIAS("dmi:*:*Acer*:TravelMate*7730G:");
+MODULE_ALIAS("dmi:*:*Acer*:TM8573T:");
 MODULE_ALIAS("dmi:*:*Gateway*:pnAOA*:");
 MODULE_ALIAS("dmi:*:*Gateway*:pnLT31*:");
 MODULE_ALIAS("dmi:*:*Packard*Bell*:pnAOA*:");
@@ -747,6 +768,7 @@ MODULE_ALIAS("dmi:*:*Packard*Bell*:pnDOTMU*:");
 MODULE_ALIAS("dmi:*:*Packard*Bell*:pnENBFT*:");
 MODULE_ALIAS("dmi:*:*Packard*Bell*:pnDOTMA*:");
 MODULE_ALIAS("dmi:*:*Packard*Bell*:pnDOTVR46*:");
+MODULE_ALIAS("dmi:*:*Acer*:pnExtensa 5420*:");
 
 module_init(acerhdf_init);
 module_exit(acerhdf_exit);
-- 
1.9.2


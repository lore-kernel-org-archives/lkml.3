Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaK1OVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 09:21:17 -0500
Received: from smtprelay06.ispgateway.de ([80.67.31.103]:35736 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaK1OVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 09:21:14 -0500
From: Peter Feuerer <peter@piie.net>
To: LKML <linux-kernel@vger.kernel.org>, Darren Hart <dvhart@infradead.org>,
        platform-driver-x86@vger.kernel.org
Cc: Peter Feuerer <peter@piie.net>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>
Subject: [RESEND PATCH v5 5/5] acerhdf: minor clean up
Date: Fri, 28 Nov 2014 15:20:52 +0100
Message-Id: <1417184452-11884-6-git-send-email-peter@piie.net>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417184452-11884-1-git-send-email-peter@piie.net>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1417184452-11884-1-git-send-email-peter@piie.net>
X-Df-Sender: cGV0ZXJAcGlpZS5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * renamed bios_settings_t to bios_settings, as it is no typedef
  * replaced "unsigned char" by u8 in bios_settings struct for better
    readability.

Cc: platform-driver-x86@vger.kernel.org
Cc: Darren Hart <dvhart@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Mohr <andi@lisas.de>
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Peter Feuerer <peter@piie.net>
---
 drivers/platform/x86/acerhdf.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 91b16c8..c07623c 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -131,18 +131,18 @@ static const struct manualcmd mcmd = {
 };
 
 /* BIOS settings */
-struct bios_settings_t {
+struct bios_settings {
 	const char *vendor;
 	const char *product;
 	const char *version;
-	unsigned char fanreg;
-	unsigned char tempreg;
+	u8 fanreg;
+	u8 tempreg;
 	struct fancmd cmd;
 	int mcmd_enable;
 };
 
 /* Register addresses and values for different BIOS versions */
-static const struct bios_settings_t bios_tbl[] = {
+static const struct bios_settings bios_tbl[] = {
 	/* AOA110 */
 	{"Acer", "AOA110", "v0.3109", 0x55, 0x58, {0x1f, 0x00}, 0},
 	{"Acer", "AOA110", "v0.3114", 0x55, 0x58, {0x1f, 0x00}, 0},
@@ -256,7 +256,7 @@ static const struct bios_settings_t bios_tbl[] = {
 	{"", "", "", 0, 0, {0, 0}, 0}
 };
 
-static const struct bios_settings_t *bios_cfg __read_mostly;
+static const struct bios_settings *bios_cfg __read_mostly;
 
 /*
  * this struct is used to instruct thermal layer to use bang_bang instead of
@@ -619,7 +619,7 @@ static int str_starts_with(const char *str, const char *start)
 static int acerhdf_check_hardware(void)
 {
 	char const *vendor, *version, *product;
-	const struct bios_settings_t *bt = NULL;
+	const struct bios_settings *bt = NULL;
 
 	/* get BIOS data */
 	vendor  = dmi_get_system_info(DMI_SYS_VENDOR);
-- 
2.1.3


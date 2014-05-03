Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaECSBM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 14:01:12 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.31]:41546 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbaECSBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 14:01:08 -0400
From: Peter Feuerer <peter@piie.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Feuerer <peter@piie.net>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>, Borislav Petkov <bp@suse.de>
Subject: [PATCH v3 6/6] acerhdf: minor clean up
Date: Sat,  3 May 2014 19:59:26 +0200
Message-Id: <1399139966-10625-7-git-send-email-peter@piie.net>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399139966-10625-1-git-send-email-peter@piie.net>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1399139966-10625-1-git-send-email-peter@piie.net>
X-Df-Sender: cGV0ZXJAcGlpZS5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * renamed bios_settings_t to bios_settings, as it is no typedef
  * replaced "unsigned char" by u8 in bios_settings struct for better
    readability.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Peter Feuerer <peter@piie.net>
---
 drivers/platform/x86/acerhdf.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index bc10260..4ecea81 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -131,19 +131,19 @@ static const struct manualcmd mcmd = {
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
@@ -257,7 +257,7 @@ static const struct bios_settings_t bios_tbl[] = {
 	{"", "", "", 0, 0, {0, 0}, 0}
 };
 
-static const struct bios_settings_t *bios_cfg __read_mostly;
+static const struct bios_settings *bios_cfg __read_mostly;
 
 /*
  * this struct is used to instruct thermal layer to use bang_bang instead of
@@ -614,7 +614,7 @@ static int str_starts_with(const char *str, const char *start)
 static int acerhdf_check_hardware(void)
 {
 	char const *vendor, *version, *product;
-	const struct bios_settings_t *bt = NULL;
+	const struct bios_settings *bt = NULL;
 
 	/* get BIOS data */
 	vendor  = dmi_get_system_info(DMI_SYS_VENDOR);
-- 
1.9.2


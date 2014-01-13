Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaAMLOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 06:14:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58219 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbaAMLOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 06:14:19 -0500
From: Takashi Iwai <tiwai@suse.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>, Oliver Neukum <oneukum@suse.de>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] ACPI: Blacklist Win8 OSI for some HP laptop 2013 models
Date: Mon, 13 Jan 2014 12:14:18 +0100
Message-Id: <1389611658-19424-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BIOS on recent HP laptops behaves differently with Win8 OSI,
e.g. no backlight control and no rfkill are available.  List them in
the blacklist as a workaround.

This patch tries to reduce the added items by matching "G1" suffix,
e.g. machines are named like "HP ProBook 430 G1".

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=856294
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---

Rafael, could you check this?
If the problem were only about the backlight, we could fix differenly,
but BIOS on these machines seems to switching more other functions
like rfkill.

thanks,

Takashi

 drivers/acpi/blacklist.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index 078c4f7fe2dd..40c91f5052ef 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -323,6 +323,56 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
 		     DMI_MATCH(DMI_PRODUCT_VERSION, "2349D15"),
 		},
 	},
+	{
+	.callback = dmi_disable_osi_win8,
+	.ident = "HP ProBook 2013 models",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "HP ProBook "),
+		     DMI_MATCH(DMI_PRODUCT_NAME, " G1"),
+		},
+	},
+	{
+	.callback = dmi_disable_osi_win8,
+	.ident = "HP EliteBook 2013 models",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook "),
+		     DMI_MATCH(DMI_PRODUCT_NAME, " G1"),
+		},
+	},
+	{
+	.callback = dmi_disable_osi_win8,
+	.ident = "HP ZBook 14",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "HP ZBook 14"),
+		},
+	},
+	{
+	.callback = dmi_disable_osi_win8,
+	.ident = "HP ZBook 15",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "HP ZBook 15"),
+		},
+	},
+	{
+	.callback = dmi_disable_osi_win8,
+	.ident = "HP ZBook 17",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "HP ZBook 17"),
+		},
+	},
+	{
+	.callback = dmi_disable_osi_win8,
+	.ident = "HP EliteBook 8780w",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook 8780w"),
+		},
+	},
 
 	/*
 	 * BIOS invocation of _OSI(Linux) is almost always a BIOS bug.
-- 
1.8.5


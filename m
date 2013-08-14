Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759980Ab3HNOSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:18:31 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:36926 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab3HNOS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:18:29 -0400
From: Kyle Evans <kvans32@gmail.com>
To: <pali.rohar@gmail.com>, <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyle Evans <kvans32@gmail.com>
Subject: [PATCH] hp-wmi; Limit hotkey enable funtion
Date: Wed, 14 Aug 2013 14:16:43 -0500
Message-Id: <1376507803-7718-1-git-send-email-kvans32@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <201308141019.53740@pali>
References: <201308141019.53740@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a supplement to commit
b253c9d1d858a3f115f791ee4fe2b9399ae7dbbd

Signed-off-by: Kyle Evans <kvans32@gmail.com>
---
 drivers/platform/x86/hp-wmi.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 97bb05e..b65014f 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -35,6 +35,7 @@
 #include <linux/input/sparse-keymap.h>
 #include <linux/platform_device.h>
 #include <linux/acpi.h>
+#include <linux/dmi.h>
 #include <linux/rfkill.h>
 #include <linux/string.h>
 
@@ -996,6 +997,17 @@ static struct platform_driver hp_wmi_driver = {
 	.remove = __exit_p(hp_wmi_bios_remove),
 };
 
+static struct dmi_system_id __initdata tx2_dmi_table[] = {
+	{
+		.ident = "tx2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "tx2"),
+		},
+	},
+	{ }
+};
+
 static int __init hp_wmi_init(void)
 {
 	int err;
@@ -1010,7 +1022,9 @@ static int __init hp_wmi_init(void)
 		if (err)
 			return err;
 
-		hp_wmi_enable_hotkeys();
+		if (dmi_check_system(tx2_dmi_table)) {
+			hp_wmi_enable_hotkeys();
+		{
 	}
 
 	if (bios_capable) {
-- 
1.7.3.4


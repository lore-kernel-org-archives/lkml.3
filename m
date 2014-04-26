Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaDZWNU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 18:13:20 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51264 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaDZWNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 18:13:18 -0400
From: poma <pomidorabelisima@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: poma <pomidorabelisima@gmail.com>, kernel@lists.fedoraproject.org,
        andreas.utterberg@thundera.se, jwboyer@fedoraproject.org,
        sgruszka@redhat.com
Subject: [PATCH] asus-nb-wmi: set wapf=4 for ASUSTeK COMPUTER INC. X75VBP & X550CA
Date: Sun, 27 Apr 2014 00:12:24 +0200
Message-Id: <1398550344-3785-1-git-send-email-pomidorabelisima@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need to set wapf to 4 for ASUSTeK COMPUTER INC. X75VBP & X550CA, so that the wireless network adapter is enabled.

References:
- asus-nb-wmi: set wapf=4 for ASUSTeK COMPUTER INC. X75VBP
http://marc.info/?l=linux-kernel&m=139819918125110
- Ath9k WiFi now disabled by radio killswitch
https://bugzilla.redhat.com/show_bug.cgi?id=1089731

Reported-by: poma <pomidorabelisima@gmail.com>
Reported-by: Andreas Utterberg <andreas.utterberg@thundera.se>
Tested-by: poma <pomidorabelisima@gmail.com>
Tested-by: Andreas Utterberg <andreas.utterberg@thundera.se>
Cc: Fedora kernel development <kernel@lists.fedoraproject.org>
Cc: Andreas Utterberg <andreas.utterberg@thundera.se>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>

---
 drivers/platform/x86/asus-nb-wmi.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 563f59e..d3641e0 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -137,6 +137,15 @@ static struct dmi_system_id asus_quirks[] = {
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. X550CA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X550CA"),
+		},
+		.driver_data = &quirk_asus_x401u,
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "ASUSTeK COMPUTER INC. X55A",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
@@ -182,6 +191,15 @@ static struct dmi_system_id asus_quirks[] = {
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. X75VBP",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X75VBP"),
+		},
+		.driver_data = &quirk_asus_x401u,
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "ASUSTeK COMPUTER INC. 1015E",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-- 
1.9.0


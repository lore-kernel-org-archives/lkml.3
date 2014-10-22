Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbaJVTP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:15:27 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56895 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbaJVTNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:13:22 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] eeepc-laptop: don't break user visible strings
Date: Wed, 22 Oct 2014 21:12:37 +0200
Message-Id: <1414005163-3461-3-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
References: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per Documentation/CodingStyle ch. 2, it is preferred that we don't
break user visible strings, in order to allow users to grep for them.

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index bb098e5..6e3be01 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -417,8 +417,7 @@ static ssize_t cpufv_disabled_store(struct device *dev,
 	switch (value) {
 	case 0:
 		if (eeepc->cpufv_disabled)
-			pr_warn("cpufv enabled (not officially supported "
-				"on this model)\n");
+			pr_warn("cpufv enabled (not officially supported on this model)\n");
 		eeepc->cpufv_disabled = false;
 		return count;
 	case 1:
@@ -604,12 +603,10 @@ static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc, acpi_handle handle)
 	absent = (l == 0xffffffff);
 
 	if (blocked != absent) {
-		pr_warn("BIOS says wireless lan is %s, "
-			"but the pci device is %s\n",
+		pr_warn("BIOS says wireless lan is %s, but the pci device is %s\n",
 			blocked ? "blocked" : "unblocked",
 			absent ? "absent" : "present");
-		pr_warn("skipped wireless hotplug as probably "
-			"inappropriate for this model\n");
+		pr_warn("skipped wireless hotplug as probably inappropriate for this model\n");
 		goto out_put_dev;
 	}
 
@@ -1295,8 +1292,8 @@ static void eeepc_dmi_check(struct eeepc_laptop *eeepc)
 	 */
 	if (strcmp(model, "701") == 0 || strcmp(model, "702") == 0) {
 		eeepc->cpufv_disabled = true;
-		pr_info("model %s does not officially support setting cpu "
-			"speed\n", model);
+		pr_info("model %s does not officially support setting cpu speed\n",
+			model);
 		pr_info("cpufv disabled to avoid instability\n");
 	}
 
@@ -1322,8 +1319,8 @@ static void cmsg_quirk(struct eeepc_laptop *eeepc, int cm, const char *name)
 	   Check if cm_getv[cm] works and, if yes, assume cm should be set. */
 	if (!(eeepc->cm_supported & (1 << cm))
 	    && !read_acpi_int(eeepc->handle, cm_getv[cm], &dummy)) {
-		pr_info("%s (%x) not reported by BIOS,"
-			" enabling anyway\n", name, 1 << cm);
+		pr_info("%s (%x) not reported by BIOS, enabling anyway\n",
+			name, 1 << cm);
 		eeepc->cm_supported |= 1 << cm;
 	}
 }
-- 
2.1.0


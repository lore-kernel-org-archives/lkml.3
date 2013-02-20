Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935238Ab3BTLND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:13:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935039Ab3BTLM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:12:58 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC 1/6] ghes_edac: remove GHES_PFX macro
Date: Wed, 20 Feb 2013 08:12:47 -0300
Message-Id: <7605d046c653e1b4f9b2092a6a99d3732ac8f125.1361358127.git.mchehab@redhat.com>
In-Reply-To: <cover.1361358127.git.mchehab@redhat.com>
References: <cover.1361358127.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Joe:

On Fri, 15 Feb 2013 08:38:17 -0800
Joe Perches <joe@perches.com> wrote:

	Perhaps these should use
	#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
	and remove GHES_PFX from all the pr_<level>()'s?

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/ghes_edac.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index 94d5286..565c516 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -1,14 +1,16 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <acpi/ghes.h>
 #include <linux/edac.h>
 #include <linux/dmi.h>
 #include "edac_core.h"
 
-#define GHES_PFX   "ghes_edac: "
 #define GHES_EDAC_REVISION " Ver: 1.0.0"
 
 static DEFINE_MUTEX(ghes_edac_lock);
 static int ghes_edac_mc_num;
 
+
 /* Memory Device - Type 17 of SMBIOS spec */
 struct memdev_dmi_entry {
 	u8 type;
@@ -80,7 +82,7 @@ static void ghes_edac_dmidecode(const struct dmi_header *dh, void *arg)
 						       dimm_fill->count, 0, 0);
 
 		if (entry->size == 0xffff) {
-			pr_info(GHES_PFX "Can't get DIMM%i size\n",
+			pr_info("Can't get DIMM%i size\n",
 				dimm_fill->count);
 			dimm->nr_pages = MiB_TO_PAGES(32);/* Unknown */
 		} else if (entry->size == 0x7fff) {
@@ -228,7 +230,7 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 	mutex_lock(&ghes_edac_lock);
 	mci = edac_mc_alloc(ghes_edac_mc_num, ARRAY_SIZE(layers), layers, 0);
 	if (!mci) {
-		pr_info(GHES_PFX "Can't allocate memory for EDAC data\n");
+		pr_info("Can't allocate memory for EDAC data\n");
 		mutex_unlock(&ghes_edac_lock);
 		return -ENOMEM;
 	}
@@ -246,17 +248,17 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 
 	if (!ghes_edac_mc_num) {
 		if (!fake) {
-			pr_info(GHES_PFX "This EDAC driver relies on BIOS to enumerate memory and get error reports.\n");
-			pr_info(GHES_PFX "Unfortunately, not all BIOSes reflect the memory layout correctly.\n");
-			pr_info(GHES_PFX "So, the end result of using this driver varies from vendor to vendor.\n");
-			pr_info(GHES_PFX "If you find incorrect reports, please contact your hardware vendor\n");
-			pr_info(GHES_PFX "to correct its BIOS.\n");
-			pr_info(GHES_PFX "This system has %d DIMM sockets.\n",
+			pr_info("This EDAC driver relies on BIOS to enumerate memory and get error reports.\n");
+			pr_info("Unfortunately, not all BIOSes reflect the memory layout correctly.\n");
+			pr_info("So, the end result of using this driver varies from vendor to vendor.\n");
+			pr_info("If you find incorrect reports, please contact your hardware vendor\n");
+			pr_info("to correct its BIOS.\n");
+			pr_info("This system has %d DIMM sockets.\n",
 				num_dimm);
 		} else {
-			pr_info(GHES_PFX "This system has a very crappy BIOS: It doesn't even list the DIMMS.\n");
-			pr_info(GHES_PFX "Its SMBIOS info is wrong. It is doubtful that the error report would\n");
-			pr_info(GHES_PFX "work on such system. Use this driver with caution\n");
+			pr_info("This system has a very crappy BIOS: It doesn't even list the DIMMS.\n");
+			pr_info("Its SMBIOS info is wrong. It is doubtful that the error report would\n");
+			pr_info("work on such system. Use this driver with caution\n");
 		}
 	}
 
@@ -287,7 +289,7 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 
 	rc = edac_mc_add_mc(mci);
 	if (rc < 0) {
-		pr_info(GHES_PFX "Can't register at EDAC core\n");
+		pr_info("Can't register at EDAC core\n");
 		edac_mc_free(mci);
 		mutex_unlock(&ghes_edac_lock);
 		return -ENODEV;
-- 
1.8.1.2


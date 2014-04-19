Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbaDTCbZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 22:31:25 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:62647 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161109AbaDTCbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 22:31:00 -0400
From: "Son P. Nguyen" <fastmutex@gmail.com>
To: gregkh@linuxfoundation.org
Cc: driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, "Son P. Nguyen" <fastmutex@gmail.com>
Subject: [PATCH 2/2] Staging: dgnc: dgnc_driver: fixed coding style braces
Date: Sat, 19 Apr 2014 22:48:11 +0000
Message-Id: <1397947691-19232-2-git-send-email-fastmutex@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1397947691-19232-1-git-send-email-fastmutex@gmail.com>
References: <1397947691-19232-1-git-send-email-fastmutex@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Son P. Nguyen" <fastmutex@gmail.com>

Fixed incorrect braces (coding style)

PS: This is for task 10 of eudyptula-challenge.

Signed-off-by: Son P. Nguyen <fastmutex@gmail.com>
---
 drivers/staging/dgnc/dgnc_driver.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index e91d3a7..c8b02f5 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -88,8 +88,7 @@ module_exit(dgnc_cleanup_module);
 /*
  * File operations permitted on Control/Management major.
  */
-static const struct file_operations dgnc_BoardFops =
-{
+static const struct file_operations dgnc_BoardFops = {
 	.owner		=	THIS_MODULE,
 	.unlocked_ioctl =  	dgnc_mgmt_ioctl,
 	.open		=	dgnc_mgmt_open,
@@ -155,8 +154,7 @@ struct board_id {
 	unsigned int is_pci_express;
 };
 
-static struct board_id dgnc_Ids[] =
-{
+static struct board_id dgnc_Ids[] = {
 	{	PCI_DEVICE_CLASSIC_4_PCI_NAME,		4,	0	},
 	{	PCI_DEVICE_CLASSIC_4_422_PCI_NAME,	4,	0	},
 	{	PCI_DEVICE_CLASSIC_8_PCI_NAME,		8,	0	},
@@ -221,9 +219,8 @@ int dgnc_init_module(void)
 	 */
 	rc = dgnc_start();
 
-	if (rc < 0) {
+	if (rc < 0)
 		return rc;
-	}
 
 	/*
 	 * Find and configure all the cards
@@ -241,8 +238,7 @@ int dgnc_init_module(void)
 			pr_warn("WARNING: dgnc driver load failed.  No Digi Neo or Classic boards found.\n");
 
 		dgnc_cleanup_module();
-	}
-	else {
+	} else {
 		dgnc_create_driver_sysfiles(&dgnc_driver);
 	}
 
@@ -521,9 +517,8 @@ static int dgnc_found_board(struct pci_dev *pdev, int id)
 
 	brd->state		= BOARD_FOUND;
 
-	for (i = 0; i < MAXPORTS; i++) {
-		brd->channels[i] = NULL;
-	}
+	for (i = 0; i < MAXPORTS; i++)
+		brd->channels[i] = NULL;	
 
 	/* store which card & revision we have */
 	pci_read_config_word(pdev, PCI_SUBSYSTEM_VENDOR_ID, &brd->subvendor);
-- 
1.8.1.2


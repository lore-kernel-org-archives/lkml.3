Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965032AbaE2JLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 05:11:14 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:56405 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965005AbaE2JLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 05:11:13 -0400
Date: Thu, 29 May 2014 18:10:27 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, dan.carpenter@oracle.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: dgap: remove useless dgap_probe1() function
Message-ID: <20140529091027.GA3783@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dgap_probe1() function is just calling dgap_found_board().
So it is removed and dgap_found_board() is called directly.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 48c13c9..808c717 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -76,7 +76,6 @@ static void dgap_poll_handler(ulong dummy);
 static int dgap_init_pci(void);
 static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static void dgap_remove_one(struct pci_dev *dev);
-static int dgap_probe1(struct pci_dev *pdev, int card_type);
 static int dgap_do_remap(struct board_t *brd);
 static irqreturn_t dgap_intr(int irq, void *voidbrd);
 
@@ -577,7 +576,7 @@ static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return -EIO;
 
-	rc = dgap_probe1(pdev, ent->driver_data);
+	rc = dgap_found_board(pdev, ent->driver_data);
 	if (rc)
 		return rc;
 
@@ -585,11 +584,6 @@ static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return dgap_firmware_load(pdev, ent->driver_data);
 }
 
-static int dgap_probe1(struct pci_dev *pdev, int card_type)
-{
-	return dgap_found_board(pdev, card_type);
-}
-
 static void dgap_remove_one(struct pci_dev *dev)
 {
 	/* Do Nothing */
-- 
1.7.1


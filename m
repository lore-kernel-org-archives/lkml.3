Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbaGDKaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:30:22 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:53209 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaGDKaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:30:21 -0400
Date: Fri, 4 Jul 2014 19:29:11 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: dgap: remove unneccessary dgap_init_pci()
 function
Message-ID: <20140704102911.GA32602@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dgap_init_pci() calls only pci_register_driver().
It doesn't need to make a function for that.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 5bccd14..b193d20 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -74,7 +74,6 @@ static struct board_t *dgap_found_board(struct pci_dev *pdev, int id,
 					int boardnum);
 static void dgap_cleanup_board(struct board_t *brd);
 static void dgap_poll_handler(ulong dummy);
-static int dgap_init_pci(void);
 static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static void dgap_remove_one(struct pci_dev *dev);
 static int dgap_do_remap(struct board_t *brd);
@@ -479,7 +478,7 @@ static int dgap_init_module(void)
 	if (rc)
 		return rc;
 
-	rc = dgap_init_pci();
+	rc = pci_register_driver(&dgap_driver);
 	if (rc)
 		goto err_cleanup;
 
@@ -563,14 +562,6 @@ failed_class:
 	return rc;
 }
 
-/*
- * Register pci driver, and return how many boards we have.
- */
-static int dgap_init_pci(void)
-{
-	return pci_register_driver(&dgap_driver);
-}
-
 static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int rc;
-- 
1.7.1


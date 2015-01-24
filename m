Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbbAXFuC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 00:50:02 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:45526 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbbAXFt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 00:49:58 -0500
From: Sakshi Bansal <sakshi.april5@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Sakshi Bansal <sakshi.april5@gmail.com>
Subject: [PATCH] Staging: dgnc: dgnc_driver.c: fixed twelve coding style warnings
Date: Sat, 24 Jan 2015 11:19:46 +0530
Message-Id: <1422078586-6316-1-git-send-email-sakshi.april5@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed 80 line warning in the code.

Signed-off-by: Sakshi Bansal <sakshi.april5@gmail.com>
---
 drivers/staging/dgnc/dgnc_driver.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index ba98ff3..86028af 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -60,7 +60,8 @@ static void		dgnc_init_globals(void);
 static int		dgnc_found_board(struct pci_dev *pdev, int id);
 static void		dgnc_cleanup_board(struct dgnc_board *brd);
 static void		dgnc_poll_handler(ulong dummy);
-static int		dgnc_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
+static int		dgnc_init_one(struct pci_dev *pdev,
+				const struct pci_device_id *ent);
 static void		dgnc_do_remap(struct dgnc_board *brd);
 
 /*
@@ -92,16 +93,22 @@ static struct class *dgnc_class;
  * Poller stuff
  */
 static DEFINE_SPINLOCK(dgnc_poll_lock); /* Poll scheduling lock */
-static ulong		dgnc_poll_time;				/* Time of next poll */
-static uint		dgnc_poll_stop;				/* Used to tell poller to stop */
+static ulong		dgnc_poll_time;				/* Time of next
+								   poll */
+static uint		dgnc_poll_stop;				/* Used to tell
+								   poller to stop */
 static struct timer_list dgnc_poll_timer;
 
 
 static struct pci_device_id dgnc_pci_tbl[] = {
-	{	DIGI_VID, PCI_DEVICE_CLASSIC_4_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	0 },
-	{	DIGI_VID, PCI_DEVICE_CLASSIC_4_422_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	1 },
-	{	DIGI_VID, PCI_DEVICE_CLASSIC_8_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	2 },
-	{	DIGI_VID, PCI_DEVICE_CLASSIC_8_422_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	3 },
+	{	DIGI_VID, PCI_DEVICE_CLASSIC_4_DID, PCI_ANY_ID, PCI_ANY_ID, 0,
+		0,	0 },
+	{	DIGI_VID, PCI_DEVICE_CLASSIC_4_422_DID, PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,	1 },
+	{	DIGI_VID, PCI_DEVICE_CLASSIC_8_DID, PCI_ANY_ID, PCI_ANY_ID, 0,
+		0,	2 },
+	{	DIGI_VID, PCI_DEVICE_CLASSIC_8_422_DID, PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,	3 },
 	{0,}						/* 0 terminated list. */
 };
 MODULE_DEVICE_TABLE(pci, dgnc_pci_tbl);
@@ -214,7 +221,8 @@ static int __init dgnc_init_module(void)
 	 * If something went wrong in the scan, bail out of driver.
 	 */
 	if (rc < 0) {
-		/* Only unregister the pci driver if it was actually registered. */
+		/* Only unregister the pci driver if it was actually registered.
+		 */
 		if (dgnc_NumBoards)
 			pci_unregister_driver(&dgnc_driver);
 		else
@@ -533,7 +541,8 @@ static int dgnc_found_board(struct pci_dev *pdev, int id)
 
 		if (brd->re_map_membase) {
 
-			/* After remap is complete, we need to read and store the dvid */
+			/* After remap is complete, we need to read and store
+			 * the dvid */
 			brd->dvid = readb(brd->re_map_membase + 0x8D);
 
 			/* Get and store the board VPD, if it exists */
@@ -586,7 +595,8 @@ static int dgnc_found_board(struct pci_dev *pdev, int id)
 	dgnc_create_ports_sysfiles(brd);
 
 	/* init our poll helper tasklet */
-	tasklet_init(&brd->helper_tasklet, brd->bd_ops->tasklet, (unsigned long) brd);
+	tasklet_init(&brd->helper_tasklet, brd->bd_ops->tasklet,
+			(unsigned long) brd);
 
 	spin_lock_irqsave(&dgnc_global_lock, flags);
 	brd->msgbuf = NULL;
@@ -688,7 +698,8 @@ static void dgnc_poll_handler(ulong dummy)
 
 		spin_lock_irqsave(&brd->bd_lock, flags);
 
-		/* If board is in a failed state, don't bother scheduling a tasklet */
+		/* If board is in a failed state, don't bother scheduling a
+		 * tasklet */
 		if (brd->state == BOARD_FAILED) {
 			spin_unlock_irqrestore(&brd->bd_lock, flags);
 			continue;
@@ -709,7 +720,8 @@ static void dgnc_poll_handler(ulong dummy)
 	new_time = dgnc_poll_time - jiffies;
 
 	if ((ulong) new_time >= 2 * dgnc_poll_tick)
-		dgnc_poll_time = jiffies +  dgnc_jiffies_from_ms(dgnc_poll_tick);
+		dgnc_poll_time = jiffies +
+				 dgnc_jiffies_from_ms(dgnc_poll_tick);
 
 	init_timer(&dgnc_poll_timer);
 	dgnc_poll_timer.function = dgnc_poll_handler;
-- 
1.9.1


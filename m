Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaDUDy7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 23:54:59 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:43449 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaDUDyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 23:54:14 -0400
From: "Son P. Nguyen" <fastmutex@gmail.com>
To: gregkh@linuxfoundation.org
Cc: driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, "Son P. Nguyen" <fastmutex@gmail.com>
Subject: [PATCH v2 2/2] Staging: dgnc: dgnc_driver: fixed incorrect braces
Date: Sun, 20 Apr 2014 18:05:39 +0000
Message-Id: <1398017139-22231-2-git-send-email-fastmutex@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1398017139-22231-1-git-send-email-fastmutex@gmail.com>
References: <1397947691-19232-2-git-send-email-fastmutex@gmail.com>
 <1398017139-22231-1-git-send-email-fastmutex@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Son P. Nguyen" <fastmutex@gmail.com>

Fixed incorrect braces (coding style)

Signed-off-by: Son P. Nguyen <fastmutex@gmail.com>
---
 drivers/staging/dgnc/dgnc_driver.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index 6af1ab3..de76eb5 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -158,8 +158,7 @@ struct board_id {
 	unsigned int is_pci_express;
 };
 
-static struct board_id dgnc_Ids[] =
-{
+static struct board_id dgnc_Ids[] = {
 	{	PCI_DEVICE_CLASSIC_4_PCI_NAME,		4,	0	},
 	{	PCI_DEVICE_CLASSIC_4_422_PCI_NAME,	4,	0	},
 	{	PCI_DEVICE_CLASSIC_8_PCI_NAME,		8,	0	},
@@ -224,9 +223,8 @@ int dgnc_init_module(void)
 	 */
 	rc = dgnc_start();
 
-	if (rc < 0) {
+	if (rc < 0)
 		return rc;
-	}
 
 	/*
 	 * Find and configure all the cards
@@ -244,8 +242,7 @@ int dgnc_init_module(void)
 			pr_warn("WARNING: dgnc driver load failed.  No Digi Neo or Classic boards found.\n");
 
 		dgnc_cleanup_module();
-	}
-	else {
+	} else {
 		dgnc_create_driver_sysfiles(&dgnc_driver);
 	}
 
@@ -524,9 +521,8 @@ static int dgnc_found_board(struct pci_dev *pdev, int id)
 
 	brd->state		= BOARD_FOUND;
 
-	for (i = 0; i < MAXPORTS; i++) {
+	for (i = 0; i < MAXPORTS; i++)
 		brd->channels[i] = NULL;
-	}
 
 	/* store which card & revision we have */
 	pci_read_config_word(pdev, PCI_SUBSYSTEM_VENDOR_ID, &brd->subvendor);
@@ -804,9 +800,8 @@ static void dgnc_poll_handler(ulong dummy)
 	 * driver tells us its up and running, and has
 	 * everything it needs.
 	 */
-	if (dgnc_driver_state != DRIVER_READY) {
+	if (dgnc_driver_state != DRIVER_READY)
 		goto schedule_poller;
-	}
 
 	/* Go thru each board, kicking off a tasklet for each if needed */
 	for (i = 0; i < dgnc_NumBoards; i++) {
@@ -836,9 +831,8 @@ schedule_poller:
 
 	new_time = dgnc_poll_time - jiffies;
 
-	if ((ulong) new_time >= 2 * dgnc_poll_tick) {
+	if ((ulong) new_time >= 2 * dgnc_poll_tick)
 		dgnc_poll_time = jiffies +  dgnc_jiffies_from_ms(dgnc_poll_tick);
-	}
 
 	init_timer(&dgnc_poll_timer);
 	dgnc_poll_timer.function = dgnc_poll_handler;
@@ -865,9 +859,8 @@ static void dgnc_init_globals(void)
 	dgnc_trcbuf_size	= trcbuf_size;
 	dgnc_debug		= debug;
 
-	for (i = 0; i < MAXBOARDS; i++) {
+	for (i = 0; i < MAXBOARDS; i++)
 		dgnc_Board[i] = NULL;
-	}
 
 	init_timer(&dgnc_poll_timer);
 }
-- 
1.8.1.2


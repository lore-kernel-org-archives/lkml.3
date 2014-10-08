Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbaJHLPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:15:21 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:64762 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaJHLPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:15:19 -0400
Date: Wed, 8 Oct 2014 20:13:21 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com
Subject: [PATCH 2/3] staging: dgap: change function names properly
Message-ID: <20141008111321.GA22008@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dgap_do_remap() and dgap_release_remap() names could be
changed to dgap_remap() and dgap_unmap().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index a48740f..7c79fe6 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -78,8 +78,8 @@ static void dgap_cleanup_board(struct board_t *brd);
 static void dgap_poll_handler(ulong dummy);
 static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static void dgap_remove_one(struct pci_dev *dev);
-static int dgap_do_remap(struct board_t *brd);
-static void dgap_release_remap(struct board_t *brd);
+static int dgap_remap(struct board_t *brd);
+static void dgap_unmap(struct board_t *brd);
 static irqreturn_t dgap_intr(int irq, void *voidbrd);
 
 static int dgap_tty_open(struct tty_struct *tty, struct file *file);
@@ -621,7 +621,7 @@ free_flipbuf:
 	dgap_free_flipbuf(brd);
 cleanup_brd:
 	dgap_cleanup_nodes();
-	dgap_release_remap(brd);
+	dgap_unmap(brd);
 	kfree(brd);
 
 	return rc;
@@ -683,7 +683,7 @@ static void dgap_cleanup_board(struct board_t *brd)
 
 	tasklet_kill(&brd->helper_tasklet);
 
-	dgap_release_remap(brd);
+	dgap_unmap(brd);
 
 	/* Free all allocated channels structs */
 	for (i = 0; i < MAXPORTS ; i++)
@@ -804,7 +804,7 @@ static struct board_t *dgap_found_board(struct pci_dev *pdev, int id,
 	tasklet_init(&brd->helper_tasklet, dgap_poll_tasklet,
 			(unsigned long) brd);
 
-	ret = dgap_do_remap(brd);
+	ret = dgap_remap(brd);
 	if (ret)
 		goto free_brd;
 
@@ -979,7 +979,7 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type,
 /*
  * Remap PCI memory.
  */
-static int dgap_do_remap(struct board_t *brd)
+static int dgap_remap(struct board_t *brd)
 {
 	if (!brd || brd->magic != DGAP_BOARD_MAGIC)
 		return -EIO;
@@ -1011,7 +1011,7 @@ static int dgap_do_remap(struct board_t *brd)
 	return 0;
 }
 
-static void dgap_release_remap(struct board_t *brd)
+static void dgap_unmap(struct board_t *brd)
 {
 	iounmap(brd->re_map_port);
 	iounmap(brd->re_map_membase);
-- 
1.7.1


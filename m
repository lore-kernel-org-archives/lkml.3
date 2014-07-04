Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbaGDKbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:31:07 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:44846 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaGDKbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:31:06 -0400
Date: Fri, 4 Jul 2014 19:29:55 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: dgap: remove unused waitqueues
Message-ID: <20140704102955.GA32610@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dgap_dl_wait and kme_wait are not used in dgap.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    8 --------
 drivers/staging/dgap/dgap.h |    1 -
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index b193d20..e8d3c99 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -218,7 +218,6 @@ static uint dgap_numboards;
 static struct board_t *dgap_board[MAXBOARDS];
 static ulong dgap_poll_counter;
 static int dgap_driver_state = DRIVER_INITIALIZED;
-static wait_queue_head_t dgap_dl_wait;
 static int dgap_poll_tick = 20;	/* Poll interval - 20 ms */
 
 static struct class *dgap_class;
@@ -1200,8 +1199,6 @@ static void dgap_init_globals(void)
 		dgap_board[i] = NULL;
 
 	init_timer(&dgap_poll_timer);
-
-	init_waitqueue_head(&dgap_dl_wait);
 }
 
 /************************************************************************
@@ -4162,11 +4159,6 @@ static int dgap_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 static int dgap_alloc_flipbuf(struct board_t *brd)
 {
 	/*
-	 * Initialize KME waitqueues...
-	 */
-	init_waitqueue_head(&brd->kme_wait);
-
-	/*
 	 * allocate flip buffer for board.
 	 */
 	brd->flipbuf = kmalloc(MYFLIPLEN, GFP_KERNEL);
diff --git a/drivers/staging/dgap/dgap.h b/drivers/staging/dgap/dgap.h
index c00b2e2..9728d59 100644
--- a/drivers/staging/dgap/dgap.h
+++ b/drivers/staging/dgap/dgap.h
@@ -603,7 +603,6 @@ struct board_t {
 					/* by DPA                         */
 	u16		dpastatus;	/* The board "status", as defined */
 					/* by DPA                         */
-	wait_queue_head_t kme_wait;	/* Needed for DPA support         */
 
 	u32		conc_dl_status;	/* Status of any pending conc     */
 					/* download                       */
-- 
1.7.1


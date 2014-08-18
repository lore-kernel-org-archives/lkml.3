Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaHROeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:34:17 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:48638 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaHROeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:34:15 -0400
Date: Mon, 18 Aug 2014 23:32:36 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: dgap: remove useless a variable within board_t
Message-ID: <20140818143236.GA21833@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use_interrupts is used only in dagp_request_irq() for checking
a value from user config file. It doesn't need in board_t struct.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    4 +---
 drivers/staging/dgap/dgap.h |    1 -
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index ff95376..8929dbf 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -837,12 +837,10 @@ static int dgap_request_irq(struct board_t *brd)
 	if (!brd || brd->magic != DGAP_BOARD_MAGIC)
 		return -ENODEV;
 
-	brd->use_interrupts = dgap_config_get_useintr(brd);
-
 	/*
 	 * Set up our interrupt handler if we are set to do interrupts.
 	 */
-	if (brd->use_interrupts && brd->irq) {
+	if (dgap_config_get_useintr(brd) && brd->irq) {
 
 		rc = request_irq(brd->irq, dgap_intr, IRQF_SHARED, "DGAP", brd);
 
diff --git a/drivers/staging/dgap/dgap.h b/drivers/staging/dgap/dgap.h
index 52e1d64..a0307b9 100644
--- a/drivers/staging/dgap/dgap.h
+++ b/drivers/staging/dgap/dgap.h
@@ -558,7 +558,6 @@ struct board_t {
 
 	u16		nasync;		/* Number of ports on card */
 
-	u32		use_interrupts;	/* Should we be interrupt driven? */
 	ulong		irq;		/* Interrupt request number */
 	ulong		intr_count;	/* Count of interrupts */
 	u32		intr_used;	/* Non-zero if using interrupts */
-- 
1.7.1


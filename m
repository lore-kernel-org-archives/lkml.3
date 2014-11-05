Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbaKEJA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:00:27 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:41015 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbaKEJAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:00:22 -0500
Date: Wed, 5 Nov 2014 17:58:11 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: dgap: remove unnecessary function
Message-ID: <20141105085811.GA26743@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dgap_init_global() initialize the dgap_board
that is a global variable as static and dgap_poll_timer.
But init_timer() is called twice in dgap_start() and dgap_board
doesn't need to be initialized to NULL.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   23 -----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 293dc33..aa393d2 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -7019,23 +7019,6 @@ static struct pci_driver dgap_driver = {
 };
 
 /*
- * dgap_init_globals()
- *
- * This is where we initialize the globals from the static insmod
- * configuration variables.  These are declared near the head of
- * this file.
- */
-static void dgap_init_globals(void)
-{
-	unsigned int i;
-
-	for (i = 0; i < MAXBOARDS; i++)
-		dgap_board[i] = NULL;
-
-	init_timer(&dgap_poll_timer);
-}
-
-/*
  * Start of driver.
  */
 static int dgap_start(void)
@@ -7044,12 +7027,6 @@ static int dgap_start(void)
 	unsigned long flags;
 	struct device *device;
 
-	/*
-	 * make sure that the globals are
-	 * init'd before we do anything else
-	 */
-	dgap_init_globals();
-
 	dgap_numboards = 0;
 
 	pr_info("For the tools package please visit http://www.digi.com\n");
-- 
1.7.1


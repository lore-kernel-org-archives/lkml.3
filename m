Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaKFK3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:29:01 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:57713 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaKFK27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:28:59 -0500
Date: Thu, 6 Nov 2014 19:26:47 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] staging: dgap: set tty's flags by tty_alloc_driver()
Message-ID: <20141106102647.GA21447@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty's flags can be set by calling tty_alloc_driver().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index aa393d2..6418cc5 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -5236,7 +5236,10 @@ static int dgap_tty_register(struct board_t *brd)
 {
 	int rc;
 
-	brd->serial_driver = tty_alloc_driver(MAXPORTS, 0);
+	brd->serial_driver = tty_alloc_driver(MAXPORTS,
+					      TTY_DRIVER_REAL_RAW |
+					      TTY_DRIVER_DYNAMIC_DEV |
+					      TTY_DRIVER_HARDWARE_BREAK);
 	if (IS_ERR(brd->serial_driver))
 		return PTR_ERR(brd->serial_driver);
 
@@ -5250,9 +5253,6 @@ static int dgap_tty_register(struct board_t *brd)
 	brd->serial_driver->subtype = SERIAL_TYPE_NORMAL;
 	brd->serial_driver->init_termios = dgap_default_termios;
 	brd->serial_driver->driver_name = DRVSTR;
-	brd->serial_driver->flags = (TTY_DRIVER_REAL_RAW |
-				    TTY_DRIVER_DYNAMIC_DEV |
-				    TTY_DRIVER_HARDWARE_BREAK);
 
 	/* The kernel wants space to store pointers to tty_structs */
 	brd->serial_driver->ttys =
@@ -5273,7 +5273,10 @@ static int dgap_tty_register(struct board_t *brd)
 	 * again, separately so we don't get the LD confused about what major
 	 * we are when we get into the dgap_tty_open() routine.
 	 */
-	brd->print_driver = tty_alloc_driver(MAXPORTS, 0);
+	brd->print_driver = tty_alloc_driver(MAXPORTS,
+					     TTY_DRIVER_REAL_RAW |
+					     TTY_DRIVER_DYNAMIC_DEV |
+					     TTY_DRIVER_HARDWARE_BREAK);
 	if (IS_ERR(brd->print_driver)) {
 		rc = PTR_ERR(brd->print_driver);
 		goto free_serial_drv;
@@ -5289,9 +5292,6 @@ static int dgap_tty_register(struct board_t *brd)
 	brd->print_driver->subtype = SERIAL_TYPE_NORMAL;
 	brd->print_driver->init_termios = dgap_default_termios;
 	brd->print_driver->driver_name = DRVSTR;
-	brd->print_driver->flags = (TTY_DRIVER_REAL_RAW |
-				   TTY_DRIVER_DYNAMIC_DEV |
-				   TTY_DRIVER_HARDWARE_BREAK);
 
 	/* The kernel wants space to store pointers to tty_structs */
 	brd->print_driver->ttys =
-- 
1.7.1


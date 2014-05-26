Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaEZKXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 06:23:46 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:53263 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaEZKXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 06:23:45 -0400
Date: Mon, 26 May 2014 19:23:01 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] staging: dgap: remove unneeded kfree() for ttys in
 tty_driver
Message-ID: <20140526102301.GA13785@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In destruct_tty_driver() from put_tty_driver() will free the
ttys in tty_driver.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 1475532..60b7d70 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -1503,8 +1503,6 @@ static void dgap_tty_uninit(struct board_t *brd)
 			tty_unregister_device(brd->serial_driver, i);
 		}
 		tty_unregister_driver(brd->serial_driver);
-		kfree(brd->serial_driver->ttys);
-		brd->serial_driver->ttys = NULL;
 		put_tty_driver(brd->serial_driver);
 		kfree(brd->serial_ports);
 		brd->dgap_major_serial_registered = FALSE;
@@ -1520,8 +1518,6 @@ static void dgap_tty_uninit(struct board_t *brd)
 			tty_unregister_device(brd->print_driver, i);
 		}
 		tty_unregister_driver(brd->print_driver);
-		kfree(brd->print_driver->ttys);
-		brd->print_driver->ttys = NULL;
 		put_tty_driver(brd->print_driver);
 		kfree(brd->printer_ports);
 		brd->dgap_major_transparent_print_registered = FALSE;
-- 
1.7.1


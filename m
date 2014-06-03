Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349AbaFCG3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 02:29:32 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:40632 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaFCG3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 02:29:31 -0400
Date: Tue, 3 Jun 2014 15:28:42 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, dan.carpenter@oracle.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] staging: dgap: rename dgap_tty_uninit() to
 dgap_cleanup_tty()
Message-ID: <20140603062842.GA7173@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- dgap_tty_uninit() doesn't match dgap_tty_init() at all.
so rename it. It is just used for cleanup when this module is
exited or failed to initialize by dgap_init_module.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index b331108..b0f2636 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -123,7 +123,7 @@ static void dgap_tty_send_xchar(struct tty_struct *tty, char ch);
 
 static int dgap_tty_register(struct board_t *brd);
 static int dgap_tty_init(struct board_t *);
-static void dgap_tty_uninit(struct board_t *);
+static void dgap_cleanup_tty(struct board_t *);
 static void dgap_carrier(struct channel_t *ch);
 static void dgap_input(struct channel_t *ch);
 
@@ -613,7 +613,7 @@ static void dgap_cleanup_module(void)
 
 	for (i = 0; i < dgap_numboards; ++i) {
 		dgap_remove_ports_sysfiles(dgap_board[i]);
-		dgap_tty_uninit(dgap_board[i]);
+		dgap_cleanup_tty(dgap_board[i]);
 		dgap_cleanup_board(dgap_board[i]);
 	}
 
@@ -1489,12 +1489,12 @@ free_chan:
 }
 
 /*
- * dgap_tty_uninit()
+ * dgap_cleanup_tty()
  *
  * Uninitialize the TTY portion of this driver.  Free all memory and
  * resources.
  */
-static void dgap_tty_uninit(struct board_t *brd)
+static void dgap_cleanup_tty(struct board_t *brd)
 {
 	struct device *dev;
 	int i;
-- 
1.7.1


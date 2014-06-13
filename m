Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaFMHmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:42:43 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35017 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaFMHmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:42:42 -0400
Date: Fri, 13 Jun 2014 16:41:47 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, dan.carpenter@oracle.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] staging: dgap: introduce dgap_tty_unregister()
Message-ID: <20140613074147.GA31615@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dgap_tty_unregister() will unregister serial_driver
and print_driver, and also free related variables.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 497e6f3..4ea7a33 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -122,6 +122,7 @@ static int dgap_tty_put_char(struct tty_struct *tty, unsigned char c);
 static void dgap_tty_send_xchar(struct tty_struct *tty, char ch);
 
 static int dgap_tty_register(struct board_t *brd);
+static void dgap_tty_unregister(struct board_t *brd);
 static int dgap_tty_init(struct board_t *);
 static void dgap_tty_free(struct board_t *);
 static void dgap_cleanup_tty(struct board_t *);
@@ -1320,6 +1321,14 @@ free_serial_drv:
 	return rc;
 }
 
+static void dgap_tty_unregister(struct board_t *brd)
+{
+	tty_unregister_driver(brd->print_driver);
+	tty_unregister_driver(brd->serial_driver);
+	put_tty_driver(brd->print_driver);
+	put_tty_driver(brd->serial_driver);
+}
+
 /*
  * dgap_tty_init()
  *
-- 
1.7.1


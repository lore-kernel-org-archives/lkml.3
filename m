Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212Ab3BLOx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:53:57 -0500
Received: from science.horizon.com ([71.41.210.146]:57572 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761280Ab3BLOxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:53:40 -0500
MBOX-Line: From ba7ad5b9cd57cae807823676f5a386ca57e997fe Mon Sep 17 00:00:00 2001
Message-Id: <ba7ad5b9cd57cae807823676f5a386ca57e997fe.1360677367.git.linux@horizon.com>
In-Reply-To: <cover.1360677367.git.linux@horizon.com>
References: <cover.1360677367.git.linux@horizon.com>
From: George Spelvin <linux@horizon.com>
Date: Fri, 8 Feb 2013 01:50:18 -0500
Subject: [PATCH v2 9/9] tty/tty_ldisc.c: use test_and_clear_bit in
 tty_ldisc_close
To: linux-serial@vger.kernel.org, peter@hurleysoftware.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, giometti@linux.it, linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a function to test and clear a bit in one step, so use it.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 drivers/tty/tty_ldisc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index c578229..4606ab9 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -453,8 +453,7 @@ static int tty_ldisc_open(struct tty_struct *tty, struct tty_ldisc *ld)
 
 static void tty_ldisc_close(struct tty_struct *tty, struct tty_ldisc *ld)
 {
-	WARN_ON(!test_bit(TTY_LDISC_OPEN, &tty->flags));
-	clear_bit(TTY_LDISC_OPEN, &tty->flags);
+	WARN_ON(!test_and_clear_bit(TTY_LDISC_OPEN, &tty->flags));
 	if (ld->ops->close)
 		ld->ops->close(tty);
 }
-- 
1.8.1.3


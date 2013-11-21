Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab3KUTNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 14:13:25 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:53069 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab3KUTNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 14:13:24 -0500
From: Andreas Platschek <andi.platschek@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Andreas Platschek <andi.platschek@gmail.com>
Subject: [PATCH] tty: replace mutex_lock() with tty_write_lock()
Date: Thu, 21 Nov 2013 20:12:12 +0100
Message-Id: <1385061132-7254-1-git-send-email-andi.platschek@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use tty_write_lock()/tty_write_unlock() consistently.

This takes care of the following sparse warning:
drivers/tty/tty_io.c:1169:17: warning: context imbalance in 'tty_write_message' - unexpected unlock

Signed-off-by: Andreas Platschek <andi.platschek@gmail.com>
---
 drivers/tty/tty_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 3a1a01a..13dca92 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1165,7 +1165,7 @@ out:
 void tty_write_message(struct tty_struct *tty, char *msg)
 {
 	if (tty) {
-		mutex_lock(&tty->atomic_write_lock);
+		tty_write_lock(tty,0);
 		tty_lock(tty);
 		if (tty->ops->write && !test_bit(TTY_CLOSING, &tty->flags)) {
 			tty_unlock(tty);
-- 
1.7.10.4


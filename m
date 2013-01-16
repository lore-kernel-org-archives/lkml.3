Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702Ab3APWg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:36:56 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:64428 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757639Ab3APWgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:36:54 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] tty: serial/68328serial.c: remove unnecessary null pointer check
Date: Wed, 16 Jan 2013 23:30:43 +0100
Message-Id: <1358375444-13026-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pointer info is dereferened in line 1009, so it is not necessary to check
null again in line 1012.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/tty/serial/68328serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
index f99a845..4f7c0d2 100644
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -1009,7 +1009,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	m68328_uart *uart = &uart_addr[info->line];
 	unsigned long flags;
 
-	if (!info || serial_paranoia_check(info, tty->name, "rs_close"))
+	if (serial_paranoia_check(info, tty->name, "rs_close"))
 		return;
 	
 	local_irq_save(flags);
-- 
1.7.10.4


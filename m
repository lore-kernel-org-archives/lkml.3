Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab3KVRKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:10:30 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:34816 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab3KVRK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:10:27 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 4/5] tty: Remove tty_prepare_flip_string_flags()
Date: Fri, 22 Nov 2013 12:09:57 -0500
Message-Id: <1385140198-5822-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385140198-5822-1-git-send-email-peter@hurleysoftware.com>
References: <1385140198-5822-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no in-tree user of tty_prepare_flip_string_flags(); remove.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c | 28 ----------------------------
 include/linux/tty_flip.h |  2 --
 2 files changed, 30 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index e8f22f8..6a3620e 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -373,34 +373,6 @@ int tty_prepare_flip_string(struct tty_port *port, unsigned char **chars,
 }
 EXPORT_SYMBOL_GPL(tty_prepare_flip_string);
 
-/**
- *	tty_prepare_flip_string_flags	-	make room for characters
- *	@port: tty port
- *	@chars: return pointer for character write area
- *	@flags: return pointer for status flag write area
- *	@size: desired size
- *
- *	Prepare a block of space in the buffer for data. Returns the length
- *	available and buffer pointer to the space which is now allocated and
- *	accounted for as ready for characters. This is used for drivers
- *	that need their own block copy routines into the buffer. There is no
- *	guarantee the buffer is a DMA target!
- */
-
-int tty_prepare_flip_string_flags(struct tty_port *port,
-			unsigned char **chars, char **flags, size_t size)
-{
-	int space = tty_buffer_request_room(port, size);
-	if (likely(space)) {
-		struct tty_buffer *tb = port->buf.tail;
-		*chars = char_buf_ptr(tb, tb->used);
-		*flags = flag_buf_ptr(tb, tb->used);
-		tb->used += space;
-	}
-	return space;
-}
-EXPORT_SYMBOL_GPL(tty_prepare_flip_string_flags);
-
 
 static int
 receive_buf(struct tty_struct *tty, struct tty_buffer *head, int count)
diff --git a/include/linux/tty_flip.h b/include/linux/tty_flip.h
index 2da8bc2..3f821e9 100644
--- a/include/linux/tty_flip.h
+++ b/include/linux/tty_flip.h
@@ -10,8 +10,6 @@ extern int tty_insert_flip_string_fixed_flag(struct tty_port *port,
 		const unsigned char *chars, char flag, size_t size);
 extern int tty_prepare_flip_string(struct tty_port *port,
 		unsigned char **chars, size_t size);
-extern int tty_prepare_flip_string_flags(struct tty_port *port,
-		unsigned char **chars, char **flags, size_t size);
 extern void tty_flip_buffer_push(struct tty_port *port);
 void tty_schedule_flip(struct tty_port *port);
 
-- 
1.8.1.2


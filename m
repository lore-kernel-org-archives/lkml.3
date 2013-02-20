Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965039Ab3BTUQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:16:51 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:55002 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965002Ab3BTUQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:16:30 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Shawn Guo <shawn.guo@linaro.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v4 11/32] n_tty: Correct unthrottle-with-buffer-flush comments
Date: Wed, 20 Feb 2013 15:02:58 -0500
Message-Id: <1361390599-15195-12-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is no longer unthrottled on buffer reset, so remove
comments that claim it is.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 0b85693..a786f4e 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -213,9 +213,8 @@ static void check_unthrottle(struct tty_struct *tty)
  *	reset_buffer_flags	-	reset buffer state
  *	@tty: terminal to reset
  *
- *	Reset the read buffer counters, clear the flags,
- *	and make sure the driver is unthrottled. Called
- *	from n_tty_open() and n_tty_flush_buffer().
+ *	Reset the read buffer counters and clear the flags.
+ *	Called from n_tty_open() and n_tty_flush_buffer().
  *
  *	Locking: tty_read_lock for read fields.
  */
@@ -254,17 +253,15 @@ static void n_tty_packet_mode_flush(struct tty_struct *tty)
  *	n_tty_flush_buffer	-	clean input queue
  *	@tty:	terminal device
  *
- *	Flush the input buffer. Called when the line discipline is
- *	being closed, when the tty layer wants the buffer flushed (eg
- *	at hangup) or when the N_TTY line discipline internally has to
- *	clean the pending queue (for example some signals).
+ *	Flush the input buffer. Called when the tty layer wants the
+ *	buffer flushed (eg at hangup) or when the N_TTY line discipline
+ *	internally has to clean the pending queue (for example some signals).
  *
  *	Locking: ctrl_lock, read_lock.
  */
 
 static void n_tty_flush_buffer(struct tty_struct *tty)
 {
-	/* clear everything and unthrottle the driver */
 	reset_buffer_flags(tty);
 
 	if (tty->link)
-- 
1.8.1.2


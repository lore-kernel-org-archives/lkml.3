Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab3KVQBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:01:40 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:54738 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab3KVP7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:59:48 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 2/7] n_tty: Un-inline slow-path n_tty_receive_char()
Date: Fri, 22 Nov 2013 10:59:20 -0500
Message-Id: <1385135965-4235-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385135965-4235-1-git-send-email-peter@hurleysoftware.com>
References: <1385135965-4235-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e60d27c4d8b33ba20896b76b6558f061bc6460ff,
n_tty: Factor LNEXT processing from per-char i/o path,
mistakenly inlined the non-inline alias, n_tty_receive_char(),
for the inline function, n_tty_receive_char_inline().

As n_tty_receive_char() is intended for slow-path char
processing only, un-inline it.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 3eb54c7..3808d3d 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1418,7 +1418,7 @@ n_tty_receive_char_inline(struct tty_struct *tty, unsigned char c)
 	put_tty_queue(c, ldata);
 }
 
-static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
+static void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 {
 	n_tty_receive_char_inline(tty, c);
 }
-- 
1.8.1.2


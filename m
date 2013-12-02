Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab3LBT2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:28:19 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:44371 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab3LBTZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:25:42 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 tty-next 2/8] n_tty: Un-inline slow-path n_tty_receive_char()
Date: Mon,  2 Dec 2013 14:24:42 -0500
Message-Id: <1386012288-5079-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386012288-5079-1-git-send-email-peter@hurleysoftware.com>
References: <1385135965-4235-1-git-send-email-peter@hurleysoftware.com>
 <1386012288-5079-1-git-send-email-peter@hurleysoftware.com>
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
index 446ccfd..86de3d0 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1420,7 +1420,7 @@ n_tty_receive_char_inline(struct tty_struct *tty, unsigned char c)
 	put_tty_queue(c, ldata);
 }
 
-static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
+static void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 {
 	n_tty_receive_char_inline(tty, c);
 }
-- 
1.8.1.2


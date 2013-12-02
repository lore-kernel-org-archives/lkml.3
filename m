Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab3LBTZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:25:48 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:44377 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3LBTZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:25:43 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 tty-next 3/8] n_tty: Un-inline slow-path n_tty_receive_char_closing()
Date: Mon,  2 Dec 2013 14:24:43 -0500
Message-Id: <1386012288-5079-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386012288-5079-1-git-send-email-peter@hurleysoftware.com>
References: <1385135965-4235-1-git-send-email-peter@hurleysoftware.com>
 <1386012288-5079-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although n_tty_receive_char_closing() only has one call-site,
let the compiler inline instead.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 86de3d0..f8a76d3 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1445,8 +1445,7 @@ n_tty_receive_char_fast(struct tty_struct *tty, unsigned char c)
 	put_tty_queue(c, ldata);
 }
 
-static inline void
-n_tty_receive_char_closing(struct tty_struct *tty, unsigned char c)
+static void n_tty_receive_char_closing(struct tty_struct *tty, unsigned char c)
 {
 	if (I_ISTRIP(tty))
 		c &= 0x7f;
-- 
1.8.1.2


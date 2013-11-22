Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab3KVQBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:01:21 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:54742 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab3KVP7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:59:50 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 3/7] n_tty: Un-inline slow-path n_tty_receive_char_closing()
Date: Fri, 22 Nov 2013 10:59:21 -0500
Message-Id: <1385135965-4235-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385135965-4235-1-git-send-email-peter@hurleysoftware.com>
References: <1385135965-4235-1-git-send-email-peter@hurleysoftware.com>
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
index 3808d3d..61edeaf 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1443,8 +1443,7 @@ n_tty_receive_char_fast(struct tty_struct *tty, unsigned char c)
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


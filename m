Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab3FOOWX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 10:22:23 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40475 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab3FOOV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 10:21:56 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 02/20] n_tty: Remove alias ptrs in __receive_buf()
Date: Sat, 15 Jun 2013 10:21:18 -0400
Message-Id: <1371306096-5571-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
References: <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
 <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The char and flag buffer local alias pointers, p and f, are
unnecessary; remove them.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 55e4e38..b8851b6 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1484,8 +1484,7 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			  char *fp, int count)
 {
 	struct n_tty_data *ldata = tty->disc_data;
-	const unsigned char *p;
-	char *f, flags = TTY_NORMAL;
+	char	flags = TTY_NORMAL;
 	char	buf[64];
 
 	if (ldata->real_raw) {
@@ -1507,19 +1506,19 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	} else {
 		int i;
 
-		for (i = count, p = cp, f = fp; i; i--, p++) {
-			if (f)
-				flags = *f++;
+		for (i = count; i; i--, cp++) {
+			if (fp)
+				flags = *fp++;
 			switch (flags) {
 			case TTY_NORMAL:
-				n_tty_receive_char(tty, *p);
+				n_tty_receive_char(tty, *cp);
 				break;
 			case TTY_BREAK:
 				n_tty_receive_break(tty);
 				break;
 			case TTY_PARITY:
 			case TTY_FRAME:
-				n_tty_receive_parity_error(tty, *p);
+				n_tty_receive_parity_error(tty, *cp);
 				break;
 			case TTY_OVERRUN:
 				n_tty_receive_overrun(tty);
-- 
1.8.1.2


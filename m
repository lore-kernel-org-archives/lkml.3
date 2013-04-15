Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab3DOPd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:33:27 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45980 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934350Ab3DOPdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:33:23 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 02/20] n_tty: Remove alias ptrs in __receive_buf()
Date: Mon, 15 Apr 2013 11:32:33 -0400
Message-Id: <1366039971-8770-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039971-8770-1-git-send-email-peter@hurleysoftware.com>
References: <1366039787-8719-1-git-send-email-peter@hurleysoftware.com>
 <1366039971-8770-1-git-send-email-peter@hurleysoftware.com>
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
index 4dbebc8..bfb04d3 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1485,8 +1485,7 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			  char *fp, int count)
 {
 	struct n_tty_data *ldata = tty->disc_data;
-	const unsigned char *p;
-	char *f, flags = TTY_NORMAL;
+	char	flags = TTY_NORMAL;
 	char	buf[64];
 
 	if (ldata->real_raw) {
@@ -1508,19 +1507,19 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
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


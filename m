Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab3FOOW2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 10:22:28 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40481 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab3FOOWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 10:22:02 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 04/20] n_tty: Rename process_char_map to char_map
Date: Sat, 15 Jun 2013 10:21:20 -0400
Message-Id: <1371306096-5571-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
References: <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
 <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 3daf9f0..caf37d3 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -92,7 +92,7 @@ struct n_tty_data {
 	size_t canon_head;
 	size_t echo_head;
 	size_t echo_commit;
-	DECLARE_BITMAP(process_char_map, 256);
+	DECLARE_BITMAP(char_map, 256);
 
 	/* private to n_tty_receive_overrun (single-threaded) */
 	unsigned long overrun_time;
@@ -1277,7 +1277,7 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 	 * handle specially, do shortcut processing to speed things
 	 * up.
 	 */
-	if (!test_bit(c, ldata->process_char_map) || ldata->lnext) {
+	if (!test_bit(c, ldata->char_map) || ldata->lnext) {
 		ldata->lnext = 0;
 		parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty)) ? 1 : 0;
 		if (read_cnt(ldata) >= (N_TTY_BUF_SIZE - parmrk - 1)) {
@@ -1617,41 +1617,38 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 	    I_ICRNL(tty) || I_INLCR(tty) || L_ICANON(tty) ||
 	    I_IXON(tty) || L_ISIG(tty) || L_ECHO(tty) ||
 	    I_PARMRK(tty)) {
-		bitmap_zero(ldata->process_char_map, 256);
+		bitmap_zero(ldata->char_map, 256);
 
 		if (I_IGNCR(tty) || I_ICRNL(tty))
-			set_bit('\r', ldata->process_char_map);
+			set_bit('\r', ldata->char_map);
 		if (I_INLCR(tty))
-			set_bit('\n', ldata->process_char_map);
+			set_bit('\n', ldata->char_map);
 
 		if (L_ICANON(tty)) {
-			set_bit(ERASE_CHAR(tty), ldata->process_char_map);
-			set_bit(KILL_CHAR(tty), ldata->process_char_map);
-			set_bit(EOF_CHAR(tty), ldata->process_char_map);
-			set_bit('\n', ldata->process_char_map);
-			set_bit(EOL_CHAR(tty), ldata->process_char_map);
+			set_bit(ERASE_CHAR(tty), ldata->char_map);
+			set_bit(KILL_CHAR(tty), ldata->char_map);
+			set_bit(EOF_CHAR(tty), ldata->char_map);
+			set_bit('\n', ldata->char_map);
+			set_bit(EOL_CHAR(tty), ldata->char_map);
 			if (L_IEXTEN(tty)) {
-				set_bit(WERASE_CHAR(tty),
-					ldata->process_char_map);
-				set_bit(LNEXT_CHAR(tty),
-					ldata->process_char_map);
-				set_bit(EOL2_CHAR(tty),
-					ldata->process_char_map);
+				set_bit(WERASE_CHAR(tty), ldata->char_map);
+				set_bit(LNEXT_CHAR(tty), ldata->char_map);
+				set_bit(EOL2_CHAR(tty), ldata->char_map);
 				if (L_ECHO(tty))
 					set_bit(REPRINT_CHAR(tty),
-						ldata->process_char_map);
+						ldata->char_map);
 			}
 		}
 		if (I_IXON(tty)) {
-			set_bit(START_CHAR(tty), ldata->process_char_map);
-			set_bit(STOP_CHAR(tty), ldata->process_char_map);
+			set_bit(START_CHAR(tty), ldata->char_map);
+			set_bit(STOP_CHAR(tty), ldata->char_map);
 		}
 		if (L_ISIG(tty)) {
-			set_bit(INTR_CHAR(tty), ldata->process_char_map);
-			set_bit(QUIT_CHAR(tty), ldata->process_char_map);
-			set_bit(SUSP_CHAR(tty), ldata->process_char_map);
+			set_bit(INTR_CHAR(tty), ldata->char_map);
+			set_bit(QUIT_CHAR(tty), ldata->char_map);
+			set_bit(SUSP_CHAR(tty), ldata->char_map);
 		}
-		clear_bit(__DISABLED_CHAR, ldata->process_char_map);
+		clear_bit(__DISABLED_CHAR, ldata->char_map);
 		ldata->raw = 0;
 		ldata->real_raw = 0;
 	} else {
-- 
1.8.1.2


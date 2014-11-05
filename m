Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbaKERlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:41:39 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:35023 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754822AbaKERkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:40:19 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 2/3] tty: Convert tty->closing to int
Date: Wed,  5 Nov 2014 12:40:04 -0500
Message-Id: <1415209205-16309-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415209205-16309-1-git-send-email-peter@hurleysoftware.com>
References: <1415209205-16309-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty->closing is a bitfield member; prevent corruption from non-atomic
update by assigning a unique memory location.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 include/linux/tty.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index c52a689..7d66ae5 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -284,7 +284,7 @@ struct tty_struct {
 
 #define N_TTY_BUF_SIZE 4096
 
-	unsigned char closing:1;
+	int closing;
 	unsigned char *write_buf;
 	int write_cnt;
 	/* If the tty has a pending do_SAK, queue it here - akpm */
-- 
2.1.3


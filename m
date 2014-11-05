Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaKERuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:50:37 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:57986 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751949AbaKERud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:50:33 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next v2 21/26] pty: Don't drop pty master tty lock to hangup slave
Date: Wed,  5 Nov 2014 12:13:04 -0500
Message-Id: <1415207589-15967-22-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
 <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the revised tty lock order and lockdep annotation, claiming
the pty slave lock is now safe while still holding the pty master lock.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/pty.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 11db7dc..bee9776 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -66,9 +66,7 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 			mutex_unlock(&devpts_mutex);
 		}
 #endif
-		tty_unlock(tty);
 		tty_vhangup(tty->link);
-		tty_lock(tty);
 	}
 }
 
-- 
2.1.3


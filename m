Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3FONXZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:23:25 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:43176 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab3FONVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:21:49 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v4 24/24] n_tty: Queue buffer work on any available cpu
Date: Sat, 15 Jun 2013 09:14:36 -0400
Message-Id: <1371302076-4688-25-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
References: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
 <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scheduling buffer work on the same cpu as the read() thread
limits the parallelism now possible between the receive_buf path
and the n_tty_read() path.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 072e52f..2321d6a 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -198,7 +198,7 @@ static void n_tty_set_room(struct tty_struct *tty)
 		 */
 		WARN_RATELIMIT(test_bit(TTY_LDISC_HALTED, &tty->flags),
 			       "scheduling buffer work for halted ldisc\n");
-		schedule_work(&tty->port->buf.work);
+		queue_work(system_unbound_wq, &tty->port->buf.work);
 	}
 }
 
-- 
1.8.1.2


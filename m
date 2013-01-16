Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764Ab3APWg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:36:58 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:52777 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757678Ab3APWg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:36:56 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-cris-kernel@axis.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] tty: serial/crisv10.c: remove unnecessary null pointer check
Date: Wed, 16 Jan 2013 23:30:44 +0100
Message-Id: <1358375444-13026-2-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358375444-13026-1-git-send-email-dinggnu@gmail.com>
References: <1358375444-13026-1-git-send-email-dinggnu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pointer tty is dereferened in line 3135, so it is not necessary to check
null again in line 3140.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/tty/serial/crisv10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index 35ee6a2..3b24965 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -3137,7 +3137,7 @@ static int rs_raw_write(struct tty_struct *tty,
 
 	/* first some sanity checks */
 
-	if (!tty || !info->xmit.buf)
+	if (!info->xmit.buf)
 		return 0;
 
 #ifdef SERIAL_DEBUG_DATA
-- 
1.7.10.4


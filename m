Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbaGJQRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:17:18 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:33742 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaGJQRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:17:15 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] drivers: tty: Remove redundant memset() in initialize_tty_struct
Date: Thu, 10 Jul 2014 18:16:24 +0200
Message-Id: <1405008984-12307-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All callers (all two) of initialize_tty_struct() have just obtained
the passed tty_struct from alloc_tty_struct(), which uses
kzalloc(). So there is no reason to clear the memory again.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/tty/tty_io.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 3411071..8199a4e 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3015,7 +3015,6 @@ static struct device *tty_get_device(struct tty_struct *tty)
 void initialize_tty_struct(struct tty_struct *tty,
 		struct tty_driver *driver, int idx)
 {
-	memset(tty, 0, sizeof(struct tty_struct));
 	kref_init(&tty->kref);
 	tty->magic = TTY_MAGIC;
 	tty_ldisc_init(tty);
-- 
1.9.2


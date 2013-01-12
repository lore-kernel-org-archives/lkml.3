Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab3ALEIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 23:08:17 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:44903 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab3ALEIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 23:08:16 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH 1/2] tty: cleanup the panic message
Date: Sat, 12 Jan 2013 05:01:21 +0100
Message-Id: <1357963283-20119-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the "\n" in panic message is excess, so we remove it in tty/pty.c as what it
is used in other places.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/tty/pty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index be6a373..64fcbdb 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -795,7 +795,7 @@ static void __init unix98_pty_init(void)
 	cdev_init(&ptmx_cdev, &ptmx_fops);
 	if (cdev_add(&ptmx_cdev, MKDEV(TTYAUX_MAJOR, 2), 1) ||
 	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 2), 1, "/dev/ptmx") < 0)
-		panic("Couldn't register /dev/ptmx driver\n");
+		panic("Couldn't register /dev/ptmx driver");
 	device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 2), NULL, "ptmx");
 }
 
-- 
1.7.10.4


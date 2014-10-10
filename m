Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbaJJN65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 09:58:57 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59611 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbaJJN6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 09:58:54 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-kernel@vger.kernel.org,
        alan@linux.intel.com
Subject: [PATCH] goldfish: fixed sparse warning
Date: Fri, 10 Oct 2014 19:28:45 +0530
Message-Id: <1412949525-17561-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed sparse warning of Using plain integer as NULL pointer

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/tty/goldfish.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/goldfish.c b/drivers/tty/goldfish.c
index 09495f5..c24b963 100644
--- a/drivers/tty/goldfish.c
+++ b/drivers/tty/goldfish.c
@@ -157,7 +157,7 @@ static int goldfish_tty_console_setup(struct console *co, char *options)
 {
 	if ((unsigned)co->index > goldfish_tty_line_count)
 		return -ENODEV;
-	if (goldfish_ttys[co->index].base == 0)
+	if (!goldfish_ttys[co->index].base)
 		return -ENODEV;
 	return 0;
 }
@@ -317,7 +317,7 @@ static int goldfish_tty_remove(struct platform_device *pdev)
 	unregister_console(&qtty->console);
 	tty_unregister_device(goldfish_tty_driver, pdev->id);
 	iounmap(qtty->base);
-	qtty->base = 0;
+	qtty->base = NULL;
 	free_irq(qtty->irq, pdev);
 	goldfish_tty_current_line_count--;
 	if (goldfish_tty_current_line_count == 0)
-- 
1.8.1.2


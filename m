Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbaI1SKd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 14:10:33 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:50646 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753352AbaI1SKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 14:10:32 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AisOAFBOKFRXQ6qa/2dsb2JhbABggw6BKrYJCwUBcppXfBcBe4QxLyOBGjeIQgGvXY8/hhKKDB2ENQWdKJVdg2U7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/1 linux-next] goldfish: fix sparse warnings
Date: Sun, 28 Sep 2014 20:10:17 +0200
Message-Id: <1411927817-31202-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/tty/goldfish.c:160:46: warning: Using plain integer as NULL pointer
drivers/tty/goldfish.c:320:22: warning: Using plain integer as NULL pointer

Signed-off-by: Fabian Frederick <fabf@skynet.be>
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
1.9.1


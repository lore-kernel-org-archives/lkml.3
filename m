Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750952Ab3JMERb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 00:17:31 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56023 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750726Ab3JMERa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 00:17:30 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: mark.gross@intel.com, arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] tlclk: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 06:17:25 +0200
Message-Id: <1381637845-6412-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/char/tlclk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tlclk.c b/drivers/char/tlclk.c
index e95e0ab..100cd1d 100644
--- a/drivers/char/tlclk.c
+++ b/drivers/char/tlclk.c
@@ -222,7 +222,7 @@ static int tlclk_open(struct inode *inode, struct file *filp)
 	/* This device is wired through the FPGA IO space of the ATCA blade
 	 * we can't share this IRQ */
 	result = request_irq(telclk_interrupt, &tlclk_interrupt,
-			     IRQF_DISABLED, "telco_clock", tlclk_interrupt);
+			     0, "telco_clock", tlclk_interrupt);
 	if (result == -EBUSY)
 		printk(KERN_ERR "tlclk: Interrupt can't be reserved.\n");
 	else
-- 
1.8.1.2


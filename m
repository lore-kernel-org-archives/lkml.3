Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963Ab3ANVqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 16:46:44 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:38561 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051Ab3ANVqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 16:46:43 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] cris: arch-v32/drivers/sync_serial.c: fix error macro position
Date: Mon, 14 Jan 2013 22:46:28 +0100
Message-Id: <1358199990-15905-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the macro CONFIG_ETRAXFS is used in wrong position - all the port[1] related
stuff should be used only when CONFIG_ETRAXFS is enabled.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 arch/cris/arch-v32/drivers/sync_serial.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/sync_serial.c b/arch/cris/arch-v32/drivers/sync_serial.c
index a6a180b..f600cd3 100644
--- a/arch/cris/arch-v32/drivers/sync_serial.c
+++ b/arch/cris/arch-v32/drivers/sync_serial.c
@@ -276,6 +276,7 @@ static int __init etrax_sync_serial_init(void)
 	initialize_port(0);
 #endif
 
+#ifdef CONFIG_ETRAXFS
 #if defined(CONFIG_ETRAX_SYNCHRONOUS_SERIAL_PORT1)
 	if (crisv32_pinmux_alloc_fixed(pinmux_sser1)) {
 		printk(KERN_WARNING
@@ -285,12 +286,10 @@ static int __init etrax_sync_serial_init(void)
 	ports[1].enabled = 1;
 	initialize_port(1);
 #endif
-
-#ifdef CONFIG_ETRAXFS
 	printk(KERN_INFO "ETRAX FS synchronous serial port driver\n");
-#else
+#else /* CONFIG_ETRAXFS */
 	printk(KERN_INFO "Artpec-3 synchronous serial port driver\n");
-#endif
+#endif /* CONFIG_ETRAXFS */
 	return 0;
 }
 
-- 
1.7.9.5


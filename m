Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab3BFWik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:38:40 -0500
Received: from mail1.bemta12.messagelabs.com ([216.82.250.242]:26113 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757844Ab3BFWij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:38:39 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-127.messagelabs.com!1360189896!7080602!43
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Organization: Vision Engraving Systems
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/11] drivers/tty: use module_pcmcia_driver() in pcmcia drivers
Date: Wed, 6 Feb 2013 15:32:01 -0700
User-Agent: KMail/1.13.5 (Linux/3.7.0; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <201302061532.02205.hsweeten@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new module_pcmcia_driver() macro to remove the boilerplate
module init/exit code in the pcmcia drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
---
 drivers/tty/serial/8250/serial_cs.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/tty/serial/8250/serial_cs.c b/drivers/tty/serial/8250/serial_cs.c
index b7d48b3..1b74b88 100644
--- a/drivers/tty/serial/8250/serial_cs.c
+++ b/drivers/tty/serial/8250/serial_cs.c
@@ -852,18 +852,6 @@ static struct pcmcia_driver serial_cs_driver = {
 	.suspend	= serial_suspend,
 	.resume		= serial_resume,
 };
-
-static int __init init_serial_cs(void)
-{
-	return pcmcia_register_driver(&serial_cs_driver);
-}
-
-static void __exit exit_serial_cs(void)
-{
-	pcmcia_unregister_driver(&serial_cs_driver);
-}
-
-module_init(init_serial_cs);
-module_exit(exit_serial_cs);
+module_pcmcia_driver(serial_cs_driver);
 
 MODULE_LICENSE("GPL");
-- 
1.8.1.1.293.gfe73786


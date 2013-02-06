Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295Ab3BFWiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:38:52 -0500
Received: from mail1.bemta12.messagelabs.com ([216.82.250.242]:34737 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758238Ab3BFWit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:38:49 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-127.messagelabs.com!1360189944!7084051!8
X-Originating-IP: [216.166.12.69]
X-StarScan-Received: 
X-StarScan-Version: 6.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Organization: Vision Engraving Systems
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/11] drivers/usb: use module_pcmcia_driver() in pcmcia drivers
Date: Wed, 6 Feb 2013 15:32:22 -0700
User-Agent: KMail/1.13.5 (Linux/3.7.0; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <201302061532.23062.hsweeten@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new module_pcmcia_driver() macro to remove the boilerplate
module init/exit code in the pcmcia drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/host/sl811_cs.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/usb/host/sl811_cs.c b/drivers/usb/host/sl811_cs.c
index 3b6f50e..469564e 100644
--- a/drivers/usb/host/sl811_cs.c
+++ b/drivers/usb/host/sl811_cs.c
@@ -200,17 +200,4 @@ static struct pcmcia_driver sl811_cs_driver = {
 	.remove		= sl811_cs_detach,
 	.id_table	= sl811_ids,
 };
-
-/*====================================================================*/
-
-static int __init init_sl811_cs(void)
-{
-	return pcmcia_register_driver(&sl811_cs_driver);
-}
-module_init(init_sl811_cs);
-
-static void __exit exit_sl811_cs(void)
-{
-	pcmcia_unregister_driver(&sl811_cs_driver);
-}
-module_exit(exit_sl811_cs);
+module_pcmcia_driver(sl811_cs_driver);
-- 
1.8.1.1.293.gfe73786


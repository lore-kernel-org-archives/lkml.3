Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab3BFW3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:29:31 -0500
Received: from mail4.bemta7.messagelabs.com ([216.82.255.53]:39495 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754839Ab3BFW33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:29:29 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-209.messagelabs.com!1360189528!7136138!89
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Organization: Vision Engraving Systems
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/11] drivers/ata: use module_pcmcia_driver() in pcmcia drivers
Date: Wed, 6 Feb 2013 15:27:27 -0700
User-Agent: KMail/1.13.5 (Linux/3.7.0; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <201302061527.27536.hsweeten@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new module_pcmcia_driver() macro to remove the boilerplate
module init/exit code in the pcmcia drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/ata/pata_pcmcia.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 958238d..40254f4 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -387,21 +387,9 @@ static struct pcmcia_driver pcmcia_driver = {
 	.probe		= pcmcia_init_one,
 	.remove		= pcmcia_remove_one,
 };
-
-static int __init pcmcia_init(void)
-{
-	return pcmcia_register_driver(&pcmcia_driver);
-}
-
-static void __exit pcmcia_exit(void)
-{
-	pcmcia_unregister_driver(&pcmcia_driver);
-}
+module_pcmcia_driver(pcmcia_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for PCMCIA ATA");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(pcmcia_init);
-module_exit(pcmcia_exit);
-- 
1.8.1.1.293.gfe73786


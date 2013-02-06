Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab3BFWgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:36:12 -0500
Received: from mail1.bemta12.messagelabs.com ([216.82.250.242]:47830 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756893Ab3BFWgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:36:09 -0500
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Feb 2013 17:36:09 EST
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-127.messagelabs.com!1360189747!6386478!6
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Organization: Vision Engraving Systems
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/11] drivers/mmc: use module_pcmcia_driver() in pcmcia drivers
Date: Wed, 6 Feb 2013 15:29:07 -0700
User-Agent: KMail/1.13.5 (Linux/3.7.0; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <201302061529.07456.hsweeten@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new module_pcmcia_driver() macro to remove the boilerplate
module init/exit code in the pcmcia drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/mmc/host/sdricoh_cs.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/mmc/host/sdricoh_cs.c b/drivers/mmc/host/sdricoh_cs.c
index 7009f17..50adbd1 100644
--- a/drivers/mmc/host/sdricoh_cs.c
+++ b/drivers/mmc/host/sdricoh_cs.c
@@ -543,25 +543,7 @@ static struct pcmcia_driver sdricoh_driver = {
 	.suspend = sdricoh_pcmcia_suspend,
 	.resume = sdricoh_pcmcia_resume,
 };
-
-/*****************************************************************************\
- *                                                                           *
- * Driver init/exit                                                          *
- *                                                                           *
-\*****************************************************************************/
-
-static int __init sdricoh_drv_init(void)
-{
-	return pcmcia_register_driver(&sdricoh_driver);
-}
-
-static void __exit sdricoh_drv_exit(void)
-{
-	pcmcia_unregister_driver(&sdricoh_driver);
-}
-
-module_init(sdricoh_drv_init);
-module_exit(sdricoh_drv_exit);
+module_pcmcia_driver(sdricoh_driver);
 
 module_param(switchlocked, uint, 0444);
 
-- 
1.8.1.1.293.gfe73786


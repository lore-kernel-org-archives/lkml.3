Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab3BFWc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:32:56 -0500
Received: from mail1.bemta8.messagelabs.com ([216.82.243.50]:22320 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755439Ab3BFWcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:32:55 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-131.messagelabs.com!1360189964!23628952!19
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Organization: Vision Engraving Systems
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/11] sound/pcmcia: use module_pcmcia_driver() in pcmcia drivers
Date: Wed, 6 Feb 2013 15:32:50 -0700
User-Agent: KMail/1.13.5 (Linux/3.7.0; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <201302061532.50523.hsweeten@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new module_pcmcia_driver() macro to remove the boilerplate
module init/exit code in the pcmcia drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 sound/pcmcia/pdaudiocf/pdaudiocf.c | 15 +--------------
 sound/pcmcia/vx/vxpocket.c         | 14 +-------------
 2 files changed, 2 insertions(+), 27 deletions(-)

diff --git a/sound/pcmcia/pdaudiocf/pdaudiocf.c b/sound/pcmcia/pdaudiocf/pdaudiocf.c
index f9b5229..8f489de 100644
--- a/sound/pcmcia/pdaudiocf/pdaudiocf.c
+++ b/sound/pcmcia/pdaudiocf/pdaudiocf.c
@@ -295,18 +295,5 @@ static struct pcmcia_driver pdacf_cs_driver = {
 	.suspend	= pdacf_suspend,
 	.resume		= pdacf_resume,
 #endif
-
 };
-
-static int __init init_pdacf(void)
-{
-	return pcmcia_register_driver(&pdacf_cs_driver);
-}
-
-static void __exit exit_pdacf(void)
-{
-	pcmcia_unregister_driver(&pdacf_cs_driver);
-}
-
-module_init(init_pdacf);
-module_exit(exit_pdacf);
+module_pcmcia_driver(pdacf_cs_driver);
diff --git a/sound/pcmcia/vx/vxpocket.c b/sound/pcmcia/vx/vxpocket.c
index 8f93504..d4db7ec 100644
--- a/sound/pcmcia/vx/vxpocket.c
+++ b/sound/pcmcia/vx/vxpocket.c
@@ -367,16 +367,4 @@ static struct pcmcia_driver vxp_cs_driver = {
 	.resume		= vxp_resume,
 #endif
 };
-
-static int __init init_vxpocket(void)
-{
-	return pcmcia_register_driver(&vxp_cs_driver);
-}
-
-static void __exit exit_vxpocket(void)
-{
-	pcmcia_unregister_driver(&vxp_cs_driver);
-}
-
-module_init(init_vxpocket);
-module_exit(exit_vxpocket);
+module_pcmcia_driver(vxp_cs_driver);
-- 
1.8.1.1.293.gfe73786


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab3BFWbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:31:32 -0500
Received: from mail4.bemta7.messagelabs.com ([216.82.255.53]:40544 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755294Ab3BFWbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:31:31 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-160.messagelabs.com!1360189887!8064826!8
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Organization: Vision Engraving Systems
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/11] drivers/parport: use module_pcmcia_driver() in pcmcia drivers
Date: Wed, 6 Feb 2013 15:31:20 -0700
User-Agent: KMail/1.13.5 (Linux/3.7.0; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <201302061531.20634.hsweeten@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new module_pcmcia_driver() macro to remove the boilerplate
module init/exit code in the pcmcia drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/parport/parport_cs.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/parport/parport_cs.c b/drivers/parport/parport_cs.c
index 067ad51..e9b52e4 100644
--- a/drivers/parport/parport_cs.c
+++ b/drivers/parport/parport_cs.c
@@ -193,16 +193,4 @@ static struct pcmcia_driver parport_cs_driver = {
 	.remove		= parport_detach,
 	.id_table	= parport_ids,
 };
-
-static int __init init_parport_cs(void)
-{
-	return pcmcia_register_driver(&parport_cs_driver);
-}
-
-static void __exit exit_parport_cs(void)
-{
-	pcmcia_unregister_driver(&parport_cs_driver);
-}
-
-module_init(init_parport_cs);
-module_exit(exit_parport_cs);
+module_pcmcia_driver(parport_cs_driver);
-- 
1.8.1.1.293.gfe73786


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab3BFW2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:28:31 -0500
Received: from mail1.bemta8.messagelabs.com ([216.82.243.50]:7610 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755064Ab3BFW2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:28:02 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-131.messagelabs.com!1360189661!22966421!33
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Organization: Vision Engraving Systems
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/11] drivers/bluetooth: use module_pcmcia_driver() in pcmcia drivers
Date: Wed, 6 Feb 2013 15:27:58 -0700
User-Agent: KMail/1.13.5 (Linux/3.7.0; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <201302061527.58779.hsweeten@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new module_pcmcia_driver() macro to remove the boilerplate
module init/exit code in the pcmcia drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/bluetooth/bluecard_cs.c | 15 +--------------
 drivers/bluetooth/bt3c_cs.c     | 15 +--------------
 drivers/bluetooth/btuart_cs.c   | 15 +--------------
 drivers/bluetooth/dtl1_cs.c     | 15 +--------------
 4 files changed, 4 insertions(+), 56 deletions(-)

diff --git a/drivers/bluetooth/bluecard_cs.c b/drivers/bluetooth/bluecard_cs.c
index 0d26851..6c3e3d4 100644
--- a/drivers/bluetooth/bluecard_cs.c
+++ b/drivers/bluetooth/bluecard_cs.c
@@ -934,17 +934,4 @@ static struct pcmcia_driver bluecard_driver = {
 	.remove		= bluecard_detach,
 	.id_table	= bluecard_ids,
 };
-
-static int __init init_bluecard_cs(void)
-{
-	return pcmcia_register_driver(&bluecard_driver);
-}
-
-
-static void __exit exit_bluecard_cs(void)
-{
-	pcmcia_unregister_driver(&bluecard_driver);
-}
-
-module_init(init_bluecard_cs);
-module_exit(exit_bluecard_cs);
+module_pcmcia_driver(bluecard_driver);
diff --git a/drivers/bluetooth/bt3c_cs.c b/drivers/bluetooth/bt3c_cs.c
index 7ffd3f4..a1aaa3b 100644
--- a/drivers/bluetooth/bt3c_cs.c
+++ b/drivers/bluetooth/bt3c_cs.c
@@ -760,17 +760,4 @@ static struct pcmcia_driver bt3c_driver = {
 	.remove		= bt3c_detach,
 	.id_table	= bt3c_ids,
 };
-
-static int __init init_bt3c_cs(void)
-{
-	return pcmcia_register_driver(&bt3c_driver);
-}
-
-
-static void __exit exit_bt3c_cs(void)
-{
-	pcmcia_unregister_driver(&bt3c_driver);
-}
-
-module_init(init_bt3c_cs);
-module_exit(exit_bt3c_cs);
+module_pcmcia_driver(bt3c_driver);
diff --git a/drivers/bluetooth/btuart_cs.c b/drivers/bluetooth/btuart_cs.c
index 35a553a..beb262f 100644
--- a/drivers/bluetooth/btuart_cs.c
+++ b/drivers/bluetooth/btuart_cs.c
@@ -688,17 +688,4 @@ static struct pcmcia_driver btuart_driver = {
 	.remove		= btuart_detach,
 	.id_table	= btuart_ids,
 };
-
-static int __init init_btuart_cs(void)
-{
-	return pcmcia_register_driver(&btuart_driver);
-}
-
-
-static void __exit exit_btuart_cs(void)
-{
-	pcmcia_unregister_driver(&btuart_driver);
-}
-
-module_init(init_btuart_cs);
-module_exit(exit_btuart_cs);
+module_pcmcia_driver(btuart_driver);
diff --git a/drivers/bluetooth/dtl1_cs.c b/drivers/bluetooth/dtl1_cs.c
index 036cb36..33f3a69 100644
--- a/drivers/bluetooth/dtl1_cs.c
+++ b/drivers/bluetooth/dtl1_cs.c
@@ -628,17 +628,4 @@ static struct pcmcia_driver dtl1_driver = {
 	.remove		= dtl1_detach,
 	.id_table	= dtl1_ids,
 };
-
-static int __init init_dtl1_cs(void)
-{
-	return pcmcia_register_driver(&dtl1_driver);
-}
-
-
-static void __exit exit_dtl1_cs(void)
-{
-	pcmcia_unregister_driver(&dtl1_driver);
-}
-
-module_init(init_dtl1_cs);
-module_exit(exit_dtl1_cs);
+module_pcmcia_driver(dtl1_driver);
-- 
1.8.1.1.293.gfe73786


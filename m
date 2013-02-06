Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab3BFW3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:29:40 -0500
Received: from mail4.bemta7.messagelabs.com ([216.82.255.53]:48742 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755064Ab3BFW3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:29:36 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-209.messagelabs.com!1360189722!7136399!2
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Organization: Vision Engraving Systems
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/11] drivers/isdn: use module_pcmcia_driver() in pcmcia drivers
Date: Wed, 6 Feb 2013 15:28:40 -0700
User-Agent: KMail/1.13.5 (Linux/3.7.0; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <201302061528.40877.hsweeten@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new module_pcmcia_driver() macro to remove the boilerplate
module init/exit code in the pcmcia drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/isdn/hardware/avm/avm_cs.c | 14 +-------------
 drivers/isdn/hisax/avma1_cs.c      | 14 +-------------
 drivers/isdn/hisax/elsa_cs.c       | 14 +-------------
 drivers/isdn/hisax/sedlbauer_cs.c  | 14 +-------------
 drivers/isdn/hisax/teles_cs.c      | 14 +-------------
 5 files changed, 5 insertions(+), 65 deletions(-)

diff --git a/drivers/isdn/hardware/avm/avm_cs.c b/drivers/isdn/hardware/avm/avm_cs.c
index c21353d..62b8030 100644
--- a/drivers/isdn/hardware/avm/avm_cs.c
+++ b/drivers/isdn/hardware/avm/avm_cs.c
@@ -163,16 +163,4 @@ static struct pcmcia_driver avmcs_driver = {
 	.remove	= avmcs_detach,
 	.id_table = avmcs_ids,
 };
-
-static int __init avmcs_init(void)
-{
-	return pcmcia_register_driver(&avmcs_driver);
-}
-
-static void __exit avmcs_exit(void)
-{
-	pcmcia_unregister_driver(&avmcs_driver);
-}
-
-module_init(avmcs_init);
-module_exit(avmcs_exit);
+module_pcmcia_driver(avmcs_driver);
diff --git a/drivers/isdn/hisax/avma1_cs.c b/drivers/isdn/hisax/avma1_cs.c
index 4e676bc..baad94e 100644
--- a/drivers/isdn/hisax/avma1_cs.c
+++ b/drivers/isdn/hisax/avma1_cs.c
@@ -159,16 +159,4 @@ static struct pcmcia_driver avma1cs_driver = {
 	.remove		= avma1cs_detach,
 	.id_table	= avma1cs_ids,
 };
-
-static int __init init_avma1_cs(void)
-{
-	return pcmcia_register_driver(&avma1cs_driver);
-}
-
-static void __exit exit_avma1_cs(void)
-{
-	pcmcia_unregister_driver(&avma1cs_driver);
-}
-
-module_init(init_avma1_cs);
-module_exit(exit_avma1_cs);
+module_pcmcia_driver(avma1cs_driver);
diff --git a/drivers/isdn/hisax/elsa_cs.c b/drivers/isdn/hisax/elsa_cs.c
index ebe5691..40f6fad 100644
--- a/drivers/isdn/hisax/elsa_cs.c
+++ b/drivers/isdn/hisax/elsa_cs.c
@@ -215,16 +215,4 @@ static struct pcmcia_driver elsa_cs_driver = {
 	.suspend	= elsa_suspend,
 	.resume		= elsa_resume,
 };
-
-static int __init init_elsa_cs(void)
-{
-	return pcmcia_register_driver(&elsa_cs_driver);
-}
-
-static void __exit exit_elsa_cs(void)
-{
-	pcmcia_unregister_driver(&elsa_cs_driver);
-}
-
-module_init(init_elsa_cs);
-module_exit(exit_elsa_cs);
+module_pcmcia_driver(elsa_cs_driver);
diff --git a/drivers/isdn/hisax/sedlbauer_cs.c b/drivers/isdn/hisax/sedlbauer_cs.c
index 90f8129..92ef62d 100644
--- a/drivers/isdn/hisax/sedlbauer_cs.c
+++ b/drivers/isdn/hisax/sedlbauer_cs.c
@@ -206,16 +206,4 @@ static struct pcmcia_driver sedlbauer_driver = {
 	.suspend	= sedlbauer_suspend,
 	.resume		= sedlbauer_resume,
 };
-
-static int __init init_sedlbauer_cs(void)
-{
-	return pcmcia_register_driver(&sedlbauer_driver);
-}
-
-static void __exit exit_sedlbauer_cs(void)
-{
-	pcmcia_unregister_driver(&sedlbauer_driver);
-}
-
-module_init(init_sedlbauer_cs);
-module_exit(exit_sedlbauer_cs);
+module_pcmcia_driver(sedlbauer_driver);
diff --git a/drivers/isdn/hisax/teles_cs.c b/drivers/isdn/hisax/teles_cs.c
index f2476ff..b8dd149 100644
--- a/drivers/isdn/hisax/teles_cs.c
+++ b/drivers/isdn/hisax/teles_cs.c
@@ -197,16 +197,4 @@ static struct pcmcia_driver teles_cs_driver = {
 	.suspend	= teles_suspend,
 	.resume		= teles_resume,
 };
-
-static int __init init_teles_cs(void)
-{
-	return pcmcia_register_driver(&teles_cs_driver);
-}
-
-static void __exit exit_teles_cs(void)
-{
-	pcmcia_unregister_driver(&teles_cs_driver);
-}
-
-module_init(init_teles_cs);
-module_exit(exit_teles_cs);
+module_pcmcia_driver(teles_cs_driver);
-- 
1.8.1.1.293.gfe73786


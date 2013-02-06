Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab3BFWbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:31:50 -0500
Received: from mail1.bemta8.messagelabs.com ([216.82.243.50]:43006 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757940Ab3BFWbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:31:49 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-131.messagelabs.com!1360189896!6047487!23
X-Originating-IP: [216.166.12.32]
X-StarScan-Received: 
X-StarScan-Version: 6.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Organization: Vision Engraving Systems
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/11] drivers/scsi: use module_pcmcia_driver() in pcmcia drivers
Date: Wed, 6 Feb 2013 15:31:41 -0700
User-Agent: KMail/1.13.5 (Linux/3.7.0; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <201302061531.41755.hsweeten@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new module_pcmcia_driver() macro to remove the boilerplate
module init/exit code in the pcmcia drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: "Juergen E. Fischer" <fischer@norbit.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/pcmcia/aha152x_stub.c | 14 +-------------
 drivers/scsi/pcmcia/fdomain_stub.c | 14 +-------------
 drivers/scsi/pcmcia/nsp_cs.c       | 17 +----------------
 drivers/scsi/pcmcia/qlogic_stub.c  | 13 +------------
 drivers/scsi/pcmcia/sym53c500_cs.c | 16 +---------------
 5 files changed, 5 insertions(+), 69 deletions(-)

diff --git a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha152x_stub.c
index 7d1609f..df82a34 100644
--- a/drivers/scsi/pcmcia/aha152x_stub.c
+++ b/drivers/scsi/pcmcia/aha152x_stub.c
@@ -220,16 +220,4 @@ static struct pcmcia_driver aha152x_cs_driver = {
 	.id_table       = aha152x_ids,
 	.resume		= aha152x_resume,
 };
-
-static int __init init_aha152x_cs(void)
-{
-	return pcmcia_register_driver(&aha152x_cs_driver);
-}
-
-static void __exit exit_aha152x_cs(void)
-{
-	pcmcia_unregister_driver(&aha152x_cs_driver);
-}
-
-module_init(init_aha152x_cs);
-module_exit(exit_aha152x_cs);
+module_pcmcia_driver(aha152x_cs_driver);
diff --git a/drivers/scsi/pcmcia/fdomain_stub.c b/drivers/scsi/pcmcia/fdomain_stub.c
index 714b248..ba84769 100644
--- a/drivers/scsi/pcmcia/fdomain_stub.c
+++ b/drivers/scsi/pcmcia/fdomain_stub.c
@@ -194,16 +194,4 @@ static struct pcmcia_driver fdomain_cs_driver = {
 	.id_table       = fdomain_ids,
 	.resume		= fdomain_resume,
 };
-
-static int __init init_fdomain_cs(void)
-{
-	return pcmcia_register_driver(&fdomain_cs_driver);
-}
-
-static void __exit exit_fdomain_cs(void)
-{
-	pcmcia_unregister_driver(&fdomain_cs_driver);
-}
-
-module_init(init_fdomain_cs);
-module_exit(exit_fdomain_cs);
+module_pcmcia_driver(fdomain_cs_driver);
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index b61a753..76ca00c 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -1773,19 +1773,4 @@ static struct pcmcia_driver nsp_driver = {
 	.suspend	= nsp_cs_suspend,
 	.resume		= nsp_cs_resume,
 };
-
-static int __init nsp_cs_init(void)
-{
-	return pcmcia_register_driver(&nsp_driver);
-}
-
-static void __exit nsp_cs_exit(void)
-{
-	pcmcia_unregister_driver(&nsp_driver);
-}
-
-
-module_init(nsp_cs_init)
-module_exit(nsp_cs_exit)
-
-/* end */
+module_pcmcia_driver(nsp_driver);
diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
index bcaf89f..8d4fdc2 100644
--- a/drivers/scsi/pcmcia/qlogic_stub.c
+++ b/drivers/scsi/pcmcia/qlogic_stub.c
@@ -300,19 +300,8 @@ static struct pcmcia_driver qlogic_cs_driver = {
 	.id_table       = qlogic_ids,
 	.resume		= qlogic_resume,
 };
-
-static int __init init_qlogic_cs(void)
-{
-	return pcmcia_register_driver(&qlogic_cs_driver);
-}
-
-static void __exit exit_qlogic_cs(void)
-{
-	pcmcia_unregister_driver(&qlogic_cs_driver);
-}
+module_pcmcia_driver(qlogic_cs_driver);
 
 MODULE_AUTHOR("Tom Zerucha, Michael Griffith");
 MODULE_DESCRIPTION("Driver for the PCMCIA Qlogic FAS SCSI controllers");
 MODULE_LICENSE("GPL");
-module_init(init_qlogic_cs);
-module_exit(exit_qlogic_cs);
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index f5b5273..55b0b2b 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -881,18 +881,4 @@ static struct pcmcia_driver sym53c500_cs_driver = {
 	.id_table       = sym53c500_ids,
 	.resume		= sym53c500_resume,
 };
-
-static int __init
-init_sym53c500_cs(void)
-{
-	return pcmcia_register_driver(&sym53c500_cs_driver);
-}
-
-static void __exit
-exit_sym53c500_cs(void)
-{
-	pcmcia_unregister_driver(&sym53c500_cs_driver);
-}
-
-module_init(init_sym53c500_cs);
-module_exit(exit_sym53c500_cs);
+module_pcmcia_driver(sym53c500_cs_driver);
-- 
1.8.1.1.293.gfe73786


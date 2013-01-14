Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab3ANU7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 15:59:34 -0500
Received: from mout.gmx.net ([212.227.17.20]:53979 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757950Ab3ANU6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 15:58:24 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19YZupXWt9YStY5EH2phKIwTR0ozhUYCmaQBrF2Nq
	bL3I+u8/zSBa41
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Peter Huewe <peterhuewe@gmx.de>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] staging/comedi/quatech_daqp_cs: Convert to module_comedi_pcmcia_driver
Date: Mon, 14 Jan 2013 22:00:51 +0100
Message-Id: <1358197255-17542-4-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1358197255-17542-1-git-send-email-peterhuewe@gmx.de>
References: <ADE657CA350FB648AAC2C43247A983F00207A6CBADD1@AUSP01VMBX24.collaborationhost.net>
 <1358197255-17542-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the boring init/exit functions with the new
module_comedi_pcmcia_driver macro.

Also removed the superflous #ifdef MODULE

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/comedi/drivers/quatech_daqp_cs.c |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
index ef0cdaa..55d8cc6 100644
--- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
@@ -1038,9 +1038,6 @@ static int daqp_cs_resume(struct pcmcia_device *link)
 }
 
 /*====================================================================*/
-
-#ifdef MODULE
-
 static const struct pcmcia_device_id daqp_cs_id_table[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x0137, 0x0027),
 	PCMCIA_DEVICE_NULL
@@ -1061,17 +1058,4 @@ static struct pcmcia_driver daqp_cs_driver = {
 	.name = "quatech_daqp_cs",
 };
 
-int __init init_module(void)
-{
-	pcmcia_register_driver(&daqp_cs_driver);
-	comedi_driver_register(&driver_daqp);
-	return 0;
-}
-
-void __exit cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_daqp);
-	pcmcia_unregister_driver(&daqp_cs_driver);
-}
-
-#endif
+module_comedi_pcmcia_driver(driver_daqp, daqp_cs_driver);
-- 
1.7.8.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829Ab3ANU6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 15:58:32 -0500
Received: from mout.gmx.net ([212.227.17.20]:60341 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758799Ab3ANU6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 15:58:30 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/NGN9l447NzGVpQ4YCiSNzjwUAJMuFiR3QOppeHt
	43SF/uFkkSCpy8
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Peter Huewe <peterhuewe@gmx.de>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] staging/comedi/ni_daq_700: Convert to module_comedi_pcmcia_driver
Date: Mon, 14 Jan 2013 22:00:54 +0100
Message-Id: <1358197255-17542-7-git-send-email-peterhuewe@gmx.de>
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

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/comedi/drivers/ni_daq_700.c |   25 +------------------------
 1 files changed, 1 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 68d7c6a..ff0e199 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -334,30 +334,7 @@ static struct pcmcia_driver daq700_cs_driver = {
 	.id_table	= daq700_cs_ids,
 };
 
-static int __init daq700_cs_init(void)
-{
-	int ret;
-
-	ret = comedi_driver_register(&daq700_driver);
-	if (ret < 0)
-		return ret;
-
-	ret = pcmcia_register_driver(&daq700_cs_driver);
-	if (ret < 0) {
-		comedi_driver_unregister(&daq700_driver);
-		return ret;
-	}
-
-	return 0;
-}
-module_init(daq700_cs_init);
-
-static void __exit daq700_cs_exit(void)
-{
-	pcmcia_unregister_driver(&daq700_cs_driver);
-	comedi_driver_unregister(&daq700_driver);
-}
-module_exit(daq700_cs_exit);
+module_comedi_pcmcia_driver(daq700_driver, daq700_cs_driver);
 
 MODULE_AUTHOR("Fred Brooks <nsaspook@nsaspook.com>");
 MODULE_DESCRIPTION(
-- 
1.7.8.6


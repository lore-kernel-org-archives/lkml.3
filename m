Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847Ab3ANU7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 15:59:14 -0500
Received: from mout.gmx.net ([212.227.17.21]:51977 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758800Ab3ANU63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 15:58:29 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19PjHRJLtJPTGc5fSVbYxVekgyCfhfcTZLD2dXLSO
	Gd5A3owrOGy3tb
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Peter Huewe <peterhuewe@gmx.de>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] staging/comedi/das08_cs: Convert to module_comedi_pcmcia_driver
Date: Mon, 14 Jan 2013 22:00:53 +0100
Message-Id: <1358197255-17542-6-git-send-email-peterhuewe@gmx.de>
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
 drivers/staging/comedi/drivers/das08_cs.c |   26 +-------------------------
 1 files changed, 1 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08_cs.c b/drivers/staging/comedi/drivers/das08_cs.c
index 0242623..73a2418 100644
--- a/drivers/staging/comedi/drivers/das08_cs.c
+++ b/drivers/staging/comedi/drivers/das08_cs.c
@@ -181,31 +181,7 @@ static struct pcmcia_driver das08_cs_driver = {
 	.id_table	= das08_cs_id_table,
 };
 
-static int __init das08_cs_init_module(void)
-{
-	int ret;
-
-	ret = comedi_driver_register(&driver_das08_cs);
-	if (ret < 0)
-		return ret;
-
-	ret = pcmcia_register_driver(&das08_cs_driver);
-	if (ret < 0) {
-		comedi_driver_unregister(&driver_das08_cs);
-		return ret;
-	}
-
-	return 0;
-
-}
-module_init(das08_cs_init_module);
-
-static void __exit das08_cs_exit_module(void)
-{
-	pcmcia_unregister_driver(&das08_cs_driver);
-	comedi_driver_unregister(&driver_das08_cs);
-}
-module_exit(das08_cs_exit_module);
+module_comedi_pcmcia_driver(driver_das08_cs, das08_cs_driver);
 
 MODULE_AUTHOR("David A. Schleef <ds@schleef.org>, "
 	      "Frank Mori Hess <fmhess@users.sourceforge.net>");
-- 
1.7.8.6


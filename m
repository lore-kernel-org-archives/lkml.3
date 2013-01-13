Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab3AMCJZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 21:09:25 -0500
Received: from mout.gmx.net ([212.227.15.18]:61474 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592Ab3AMCJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 21:09:22 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19dNecgb2NdDWm1QDCXFwW02LmHvmg/2nWfWgePqC
	rKP/gw3kxSHzle
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Peter Huewe <peterhuewe@gmx.de>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] staging/comedi/cb_das16_cs: Convert to module_comedi_pcmcia_driver
Date: Sun, 13 Jan 2013 03:11:10 +0100
Message-Id: <1358043073-12328-5-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1358043073-12328-1-git-send-email-peterhuewe@gmx.de>
References: <1358043073-12328-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the boring init/exit functions with the new
module_comedi_pcmcia_driver macro.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c |   25 +------------------------
 1 files changed, 1 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 93731de..e253fc0 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -548,30 +548,7 @@ static struct pcmcia_driver das16cs_driver = {
 	.id_table	= das16cs_id_table,
 };
 
-static int __init das16cs_init(void)
-{
-	int ret;
-
-	ret = comedi_driver_register(&driver_das16cs);
-	if (ret < 0)
-		return ret;
-
-	ret = pcmcia_register_driver(&das16cs_driver);
-	if (ret < 0) {
-		comedi_driver_unregister(&driver_das16cs);
-		return ret;
-	}
-
-	return 0;
-}
-module_init(das16cs_init);
-
-static void __exit das16cs_exit(void)
-{
-	pcmcia_unregister_driver(&das16cs_driver);
-	comedi_driver_unregister(&driver_das16cs);
-}
-module_exit(das16cs_exit);
+module_comedi_pcmcia_driver(driver_das16cs, das16cs_driver);
 
 MODULE_AUTHOR("David A. Schleef <ds@schleef.org>");
 MODULE_DESCRIPTION("Comedi driver for Computer Boards PC-CARD DAS16/16");
-- 
1.7.8.6


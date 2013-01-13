Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab3AMCJG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 21:09:06 -0500
Received: from mout.gmx.net ([212.227.15.18]:64507 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844Ab3AMCJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 21:09:04 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18DBTQ+atsDhUTJMikSeulyWhmatgrnVyQsTqkZNL
	6jEOq/fPArdyNk
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Peter Huewe <peterhuewe@gmx.de>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] staging/comedi/ni_mio_cs: Convert to module_comedi_pcmcia_driver
Date: Sun, 13 Jan 2013 03:11:08 +0100
Message-Id: <1358043073-12328-3-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1358043073-12328-1-git-send-email-peterhuewe@gmx.de>
References: <1358043073-12328-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the boring init/exit functions with the new
module_comedi_pcmcia_driver macro.

Also removed the superflous #ifdef MODULE

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/comedi/drivers/ni_mio_cs.c |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_mio_cs.c b/drivers/staging/comedi/drivers/ni_mio_cs.c
index 76c6a13..b5c5d58 100644
--- a/drivers/staging/comedi/drivers/ni_mio_cs.c
+++ b/drivers/staging/comedi/drivers/ni_mio_cs.c
@@ -408,8 +408,6 @@ static int ni_getboardtype(struct comedi_device *dev,
 	return 0;
 }
 
-#ifdef MODULE
-
 static const struct pcmcia_device_id ni_mio_cs_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x010b, 0x010d),	/* DAQCard-ai-16xe-50 */
 	PCMCIA_DEVICE_MANF_CARD(0x010b, 0x010c),	/* DAQCard-ai-16e-4 */
@@ -434,20 +432,4 @@ static struct pcmcia_driver ni_mio_cs_driver = {
 	.name = "ni_mio_cs",
 };
 
-int init_module(void)
-{
-	pcmcia_register_driver(&ni_mio_cs_driver);
-	comedi_driver_register(&driver_ni_mio_cs);
-	return 0;
-}
-
-void cleanup_module(void)
-{
-	pcmcia_unregister_driver(&ni_mio_cs_driver);
-#if 0
-	while (cur_dev != NULL)
-		cs_detach(cur_dev->handle);
-#endif
-	comedi_driver_unregister(&driver_ni_mio_cs);
-}
-#endif
+module_comedi_pcmcia_driver(driver_ni_mio_cs, ni_mio_cs_driver);
-- 
1.7.8.6


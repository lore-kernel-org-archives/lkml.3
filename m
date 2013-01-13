Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab3AMCIy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 21:08:54 -0500
Received: from mout.gmx.net ([212.227.17.21]:54988 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480Ab3AMCIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 21:08:53 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18fi3Vp7gIff4Hv0mdgKcgIpW7haR4MQAhYccuo1e
	BHiExAqiTzFgXu
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Peter Huewe <peterhuewe@gmx.de>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] staging/comedi/ni_daq_dio24: Convert to module_comedi_pcmcia_driver
Date: Sun, 13 Jan 2013 03:11:07 +0100
Message-Id: <1358043073-12328-2-git-send-email-peterhuewe@gmx.de>
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
 drivers/staging/comedi/drivers/ni_daq_dio24.c |   29 +------------------------
 1 files changed, 1 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_dio24.c b/drivers/staging/comedi/drivers/ni_daq_dio24.c
index 7b33335..dd22691 100644
--- a/drivers/staging/comedi/drivers/ni_daq_dio24.c
+++ b/drivers/staging/comedi/drivers/ni_daq_dio24.c
@@ -318,31 +318,4 @@ static struct pcmcia_driver dio24_cs_driver = {
 	.name = "ni_daq_dio24",
 };
 
-static int __init init_dio24_cs(void)
-{
-	printk("ni_daq_dio24: HOLA SOY YO!\n");
-	pcmcia_register_driver(&dio24_cs_driver);
-	return 0;
-}
-
-static void __exit exit_dio24_cs(void)
-{
-	pcmcia_unregister_driver(&dio24_cs_driver);
-}
-
-int __init init_module(void)
-{
-	int ret;
-
-	ret = init_dio24_cs();
-	if (ret < 0)
-		return ret;
-
-	return comedi_driver_register(&driver_dio24);
-}
-
-void __exit cleanup_module(void)
-{
-	exit_dio24_cs();
-	comedi_driver_unregister(&driver_dio24);
-}
+module_comedi_pcmcia_driver(driver_dio24, dio24_cs_driver);
-- 
1.7.8.6


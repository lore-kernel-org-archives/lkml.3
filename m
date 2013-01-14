Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab3ANU6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 15:58:34 -0500
Received: from mout.gmx.net ([212.227.17.21]:57409 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758816Ab3ANU6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 15:58:31 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19LpUkCmEtLTcAllKP6oaU5BG+j0c39bO16TxHmUh
	gvySBknK7YtDJm
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Peter Huewe <peterhuewe@gmx.de>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] staging/comedi/ni_labpc_cs: Convert to module_comedi_pcmcia_driver
Date: Mon, 14 Jan 2013 22:00:55 +0100
Message-Id: <1358197255-17542-8-git-send-email-peterhuewe@gmx.de>
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
 drivers/staging/comedi/drivers/ni_labpc_cs.c |   31 +-------------------------
 1 files changed, 1 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc_cs.c b/drivers/staging/comedi/drivers/ni_labpc_cs.c
index bfe19fa..b26496d 100644
--- a/drivers/staging/comedi/drivers/ni_labpc_cs.c
+++ b/drivers/staging/comedi/drivers/ni_labpc_cs.c
@@ -282,33 +282,4 @@ static struct pcmcia_driver labpc_cs_driver = {
 	.name = "daqcard-1200",
 };
 
-static int __init init_labpc_cs(void)
-{
-	pcmcia_register_driver(&labpc_cs_driver);
-	return 0;
-}
-
-static void __exit exit_labpc_cs(void)
-{
-	pcmcia_unregister_driver(&labpc_cs_driver);
-}
-
-static int __init labpc_init_module(void)
-{
-	int ret;
-
-	ret = init_labpc_cs();
-	if (ret < 0)
-		return ret;
-
-	return comedi_driver_register(&driver_labpc_cs);
-}
-
-static void __exit labpc_exit_module(void)
-{
-	exit_labpc_cs();
-	comedi_driver_unregister(&driver_labpc_cs);
-}
-
-module_init(labpc_init_module);
-module_exit(labpc_exit_module);
+module_comedi_pcmcia_driver(driver_labpc_cs, labpc_cs_driver);
-- 
1.7.8.6


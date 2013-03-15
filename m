Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab3COKte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 06:49:34 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:46219 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab3COKtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 06:49:33 -0400
From: Fabio Porcedda <fabio.porcedda@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Porter <mporter@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] parport: amiga: use module_platform_driver_probe()
Date: Fri, 15 Mar 2013 11:49:27 +0100
Message-Id: <1363344567-26721-1-git-send-email-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use module_platform_driver_probe() macro which makes the code smaller
and simpler.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: Matt Porter <mporter@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parport/parport_amiga.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/parport/parport_amiga.c b/drivers/parport/parport_amiga.c
index ee78e0e..09503b8 100644
--- a/drivers/parport/parport_amiga.c
+++ b/drivers/parport/parport_amiga.c
@@ -244,20 +244,7 @@ static struct platform_driver amiga_parallel_driver = {
 	},
 };
 
-static int __init amiga_parallel_init(void)
-{
-	return platform_driver_probe(&amiga_parallel_driver,
-				     amiga_parallel_probe);
-}
-
-module_init(amiga_parallel_init);
-
-static void __exit amiga_parallel_exit(void)
-{
-	platform_driver_unregister(&amiga_parallel_driver);
-}
-
-module_exit(amiga_parallel_exit);
+module_platform_driver_probe(amiga_parallel_driver, amiga_parallel_probe);
 
 MODULE_AUTHOR("Joerg Dorchain <joerg@dorchain.net>");
 MODULE_DESCRIPTION("Parport Driver for Amiga builtin Port");
-- 
1.8.1.5


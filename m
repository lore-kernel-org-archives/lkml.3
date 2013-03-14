Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965010Ab3CNRJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 13:09:59 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:62552 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964868Ab3CNRJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 13:09:54 -0400
From: Fabio Porcedda <fabio.porcedda@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-input@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benoit Cousson <b-cousson@ti.com>, Aneesh V <aneesh@ti.com>
Subject: [PATCH v2 5/8] drivers: memory: use module_platform_driver_probe()
Date: Thu, 14 Mar 2013 18:09:35 +0100
Message-Id: <1363280978-24051-6-git-send-email-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363280978-24051-1-git-send-email-fabio.porcedda@gmail.com>
References: <1363280978-24051-1-git-send-email-fabio.porcedda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers to use the
module_platform_driver_probe() macro which makes the code smaller and
a bit simpler.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Aneesh V <aneesh@ti.com>
---
 drivers/memory/emif.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index df08736..ecbc1a9 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -1841,18 +1841,8 @@ static struct platform_driver emif_driver = {
 	},
 };
 
-static int __init_or_module emif_register(void)
-{
-	return platform_driver_probe(&emif_driver, emif_probe);
-}
-
-static void __exit emif_unregister(void)
-{
-	platform_driver_unregister(&emif_driver);
-}
+module_platform_driver_probe(emif_driver, emif_probe);
 
-module_init(emif_register);
-module_exit(emif_unregister);
 MODULE_DESCRIPTION("TI EMIF SDRAM Controller Driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:emif");
-- 
1.8.1.5


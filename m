Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934Ab3CNRJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 13:09:51 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:44147 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964868Ab3CNRJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 13:09:47 -0400
From: Fabio Porcedda <fabio.porcedda@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-input@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH v2 2/8] drivers: ata: use module_platform_driver_probe()
Date: Thu, 14 Mar 2013 18:09:32 +0100
Message-Id: <1363280978-24051-3-git-send-email-fabio.porcedda@gmail.com>
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
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org
---
 drivers/ata/pata_at32.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/ata/pata_at32.c b/drivers/ata/pata_at32.c
index 36f189c..8d493b4 100644
--- a/drivers/ata/pata_at32.c
+++ b/drivers/ata/pata_at32.c
@@ -393,18 +393,7 @@ static struct platform_driver pata_at32_driver = {
 	},
 };
 
-static int __init pata_at32_init(void)
-{
-	return platform_driver_probe(&pata_at32_driver, pata_at32_probe);
-}
-
-static void __exit pata_at32_exit(void)
-{
-	platform_driver_unregister(&pata_at32_driver);
-}
-
-module_init(pata_at32_init);
-module_exit(pata_at32_exit);
+module_platform_driver_probe(pata_at32_driver, pata_at32_probe);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("AVR32 SMC/CFC PATA Driver");
-- 
1.8.1.5


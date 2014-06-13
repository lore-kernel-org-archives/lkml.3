Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaFMUCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:02:19 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.39]:33873 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaFMUCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:02:18 -0400
From: Christoph Jaeger <christophjaeger@linux.com>
To: jdelvare@suse.de, wsa@the-dreams.de
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <christophjaeger@linux.com>
Subject: [PATCH] i2c-taos-evm: Use module_serio_driver()
Date: Fri, 13 Jun 2014 21:52:24 +0200
Message-Id: <1402689144-20259-1-git-send-email-christophjaeger@linux.com>
X-Mailer: git-send-email 1.9.3
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of some boilerplate code by using module_serio_driver().

Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
---
 drivers/i2c/busses/i2c-taos-evm.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/i2c/busses/i2c-taos-evm.c b/drivers/i2c/busses/i2c-taos-evm.c
index 0576026..10855a0 100644
--- a/drivers/i2c/busses/i2c-taos-evm.c
+++ b/drivers/i2c/busses/i2c-taos-evm.c
@@ -311,19 +311,8 @@ static struct serio_driver taos_drv = {
 	.interrupt	= taos_interrupt,
 };
 
-static int __init taos_init(void)
-{
-	return serio_register_driver(&taos_drv);
-}
-
-static void __exit taos_exit(void)
-{
-	serio_unregister_driver(&taos_drv);
-}
+module_serio_driver(taos_drv);
 
 MODULE_AUTHOR("Jean Delvare <jdelvare@suse.de>");
 MODULE_DESCRIPTION("TAOS evaluation module driver");
 MODULE_LICENSE("GPL");
-
-module_init(taos_init);
-module_exit(taos_exit);
-- 
1.9.3


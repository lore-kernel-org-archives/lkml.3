Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986Ab3K0TL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 14:11:57 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50931 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815Ab3K0TIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 14:08:07 -0500
From: Felipe Balbi <balbi@ti.com>
To: <sameo@linux.intel.com>
CC: <lee.jones@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 02/13] mfd: menelaus: switch over to module_i2c_driver
Date: Wed, 27 Nov 2013 13:06:46 -0600
Message-ID: <1385579217-20127-3-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
In-Reply-To: <1385579217-20127-1-git-send-email-balbi@ti.com>
References: <1385579217-20127-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

just a macro to remove some boilerplate code,
no functional changes.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/menelaus.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index 975ff9e..8bd97ca 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -1287,29 +1287,8 @@ static struct i2c_driver menelaus_i2c_driver = {
 	.id_table	= menelaus_id,
 };
 
-static int __init menelaus_init(void)
-{
-	int res;
-
-	res = i2c_add_driver(&menelaus_i2c_driver);
-	if (res < 0) {
-		pr_err(DRIVER_NAME ": driver registration failed\n");
-		return res;
-	}
-
-	return 0;
-}
-
-static void __exit menelaus_exit(void)
-{
-	i2c_del_driver(&menelaus_i2c_driver);
-
-	/* FIXME: Shutdown menelaus parts that can be shut down */
-}
+module_i2c_driver(menelaus_i2c_driver);
 
 MODULE_AUTHOR("Texas Instruments, Inc. (and others)");
 MODULE_DESCRIPTION("I2C interface for Menelaus.");
 MODULE_LICENSE("GPL");
-
-module_init(menelaus_init);
-module_exit(menelaus_exit);
-- 
1.8.4.GIT


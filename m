Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab3LCDov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 22:44:51 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56533 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546Ab3LCDoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 22:44:34 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>
CC: Aaro Koskinen <aaro.koskinen@iki.fi>, <sameo@linux.intel.com>,
        Tony Lindgren <tony@atomide.com>, <lee.jones@linaro.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH v2 01/15] mfd: menelaus: Drop __exit section annotation
Date: Mon, 2 Dec 2013 21:42:54 -0600
Message-ID: <1386042188-12246-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we could build that as a driver.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/menelaus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index ad25bfa..975ff9e 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -1262,7 +1262,7 @@ fail:
 	return err;
 }
 
-static int __exit menelaus_remove(struct i2c_client *client)
+static int menelaus_remove(struct i2c_client *client)
 {
 	struct menelaus_chip	*menelaus = i2c_get_clientdata(client);
 
@@ -1283,7 +1283,7 @@ static struct i2c_driver menelaus_i2c_driver = {
 		.name		= DRIVER_NAME,
 	},
 	.probe		= menelaus_probe,
-	.remove		= __exit_p(menelaus_remove),
+	.remove		= menelaus_remove,
 	.id_table	= menelaus_id,
 };
 
-- 
1.8.4.GIT


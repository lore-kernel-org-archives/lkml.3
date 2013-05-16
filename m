Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab3EPNRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:17:12 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:40582 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab3EPNRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:17:11 -0400
Message-ID: <1368710224.5500.1.camel@phoenix>
Subject: [PATCH] power_supply: pm2301_charger: Return error if
 create_singlethread_workqueue fails
From: Axel Lin <axel.lin@ingics.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Michel JAOUEN <michel.jaouen@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Date: Thu, 16 May 2013 21:17:04 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return error instead of 0 if create_singlethread_workqueue call fails.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/power/pm2301_charger.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index c972389..6ae3957 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -1075,9 +1075,9 @@ static int pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 	pm2->ac_chg.external = true;
 
 	/* Create a work queue for the charger */
-	pm2->charger_wq =
-		create_singlethread_workqueue("pm2xxx_charger_wq");
+	pm2->charger_wq = create_singlethread_workqueue("pm2xxx_charger_wq");
 	if (pm2->charger_wq == NULL) {
+		ret = -ENOMEM;
 		dev_err(pm2->dev, "failed to create work queue\n");
 		goto free_device_info;
 	}
-- 
1.8.1.2




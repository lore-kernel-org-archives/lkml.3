Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab3EPJbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 05:31:14 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:45591 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3EPJbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 05:31:07 -0400
Message-ID: <1368696660.8439.1.camel@phoenix>
Subject: [PATCH] power_supply: pm2301_charger: Fix NULL pointer dereference
From: Axel Lin <axel.lin@ingics.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Michel JAOUEN <michel.jaouen@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Date: Thu, 16 May 2013 17:31:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add checking pl_data in probe, this prevent possible NULL pointer dereference.
Also fix NULL pointer deference in dev_err when allocate memory for pm2 fails.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/power/pm2301_charger.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index a441751..c972389 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -1007,9 +1007,14 @@ static int pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 	u8 val;
 	int i;
 
+	if (!pl_data) {
+		dev_err(&i2c_client->dev, "No platform data supplied\n");
+		return -EINVAL;
+	}
+
 	pm2 = kzalloc(sizeof(struct pm2xxx_charger), GFP_KERNEL);
 	if (!pm2) {
-		dev_err(pm2->dev, "pm2xxx_charger allocation failed\n");
+		dev_err(&i2c_client->dev, "pm2xxx_charger allocation failed\n");
 		return -ENOMEM;
 	}
 
-- 
1.8.1.2




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab3G3VOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 17:14:40 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:50480 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732Ab3G3VOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 17:14:38 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: lm-sensors@lm-sensors.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: [PATCH] hwmon: (max6697) fix MAX6581 ideality
Date: Tue, 30 Jul 2013 17:14:34 -0400
Message-Id: <1375218874-10882-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch, the values for ideality (register 0x4b) and ideality
selection mask (register 0x4c) are inverted.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 drivers/hwmon/max6697.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/max6697.c b/drivers/hwmon/max6697.c
index 328fb03..a41b5f3 100644
--- a/drivers/hwmon/max6697.c
+++ b/drivers/hwmon/max6697.c
@@ -605,12 +605,12 @@ static int max6697_init_chip(struct i2c_client *client)
 		if (ret < 0)
 			return ret;
 		ret = i2c_smbus_write_byte_data(client, MAX6581_REG_IDEALITY,
-						pdata->ideality_mask >> 1);
+						pdata->ideality_value);
 		if (ret < 0)
 			return ret;
 		ret = i2c_smbus_write_byte_data(client,
 						MAX6581_REG_IDEALITY_SELECT,
-						pdata->ideality_value);
+						pdata->ideality_mask >> 1);
 		if (ret < 0)
 			return ret;
 	}
-- 
1.8.3.4


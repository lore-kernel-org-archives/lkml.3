Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbaI3Voq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:44:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32906 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbaI3Vi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Robert Coulson <rob.coulson@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 084/103] hwmon: (ds1621) Update zbits after conversion rate change
Date: Tue, 30 Sep 2014 14:31:29 -0700
Message-Id: <1412112708-27356-85-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Coulson <rob.coulson@gmail.com>

commit 39c627a084475e8a690a4a9e7601410ca173ddd2 upstream.

After the conversion rate is changed, the zbits are not updated,
but should be, since they are used later in the set_temp function.

Fixes: a50d9a4d9ad3 ("hwmon: (ds1621) Fix temperature rounding operations")
Reported-by: Murat Ilsever <murat.ilsever@gmail.com>
Signed-off-by: Robert Coulson <rob.coulson@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hwmon/ds1621.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/ds1621.c b/drivers/hwmon/ds1621.c
index 872d767..b96d201 100644
--- a/drivers/hwmon/ds1621.c
+++ b/drivers/hwmon/ds1621.c
@@ -309,6 +309,7 @@ static ssize_t set_convrate(struct device *dev, struct device_attribute *da,
 	data->conf |= (resol << DS1621_REG_CONFIG_RESOL_SHIFT);
 	i2c_smbus_write_byte_data(client, DS1621_REG_CONF, data->conf);
 	data->update_interval = ds1721_convrates[resol];
+	data->zbits = 7 - resol;
 	mutex_unlock(&data->update_lock);
 
 	return count;
-- 
1.9.1


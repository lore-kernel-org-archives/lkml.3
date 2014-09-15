Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbaIOWPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:15:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50890 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784AbaIOWPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:15:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 164/187] hwmon: (ads1015) Fix out-of-bounds array access
Date: Mon, 15 Sep 2014 15:09:34 -0700
Message-Id: <1410818997-9432-165-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit e981429557cbe10c780fab1c1a237cb832757652 upstream.

Current code uses data_rate as array index in ads1015_read_adc() and uses pga
as array index in ads1015_reg_to_mv, so we must make sure both data_rate and
pga settings are in valid value range.
Return -EINVAL if the setting is out-of-range.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hwmon/ads1015.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwmon/ads1015.c b/drivers/hwmon/ads1015.c
index 22e0c92..1265164 100644
--- a/drivers/hwmon/ads1015.c
+++ b/drivers/hwmon/ads1015.c
@@ -212,6 +212,7 @@ static int ads1015_get_channels_config_of(struct i2c_client *client)
 				dev_err(&client->dev,
 					"invalid gain on %s\n",
 					node->full_name);
+				return -EINVAL;
 			}
 		}
 
@@ -222,6 +223,7 @@ static int ads1015_get_channels_config_of(struct i2c_client *client)
 				dev_err(&client->dev,
 					"invalid data_rate on %s\n",
 					node->full_name);
+				return -EINVAL;
 			}
 		}
 
-- 
1.9.1


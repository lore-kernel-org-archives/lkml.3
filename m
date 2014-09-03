Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbaICJ4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:56:13 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57351 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756148AbaICJ4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:56:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Guenter Roeck <linux@roeck-us.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 36/56] hwmon: (ads1015) Fix out-of-bounds array access
Date: Wed,  3 Sep 2014 11:26:55 +0200
Message-Id: <5c10fcc0fa579d11f82a87efa367bb040f433457.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e981429557cbe10c780fab1c1a237cb832757652 upstream.

Current code uses data_rate as array index in ads1015_read_adc() and uses pga
as array index in ads1015_reg_to_mv, so we must make sure both data_rate and
pga settings are in valid value range.
Return -EINVAL if the setting is out-of-range.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hwmon/ads1015.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwmon/ads1015.c b/drivers/hwmon/ads1015.c
index 22e0c926989d..126516414c11 100644
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
2.1.0


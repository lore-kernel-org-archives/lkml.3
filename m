Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbaICKDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:03:14 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57449 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932417AbaICJ6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:58:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Guenter Roeck <linux@roeck-us.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 34/56] hwmon: (ads1015) Fix off-by-one for valid channel index checking
Date: Wed,  3 Sep 2014 11:26:53 +0200
Message-Id: <aaadf801c0129fe09dab90bf49116a141bc4006a.1409735865.git.jslaby@suse.cz>
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

commit 56de1377ad92f72ee4e5cb0faf7a9b6048fdf0bf upstream.

Current code uses channel as array index, so the valid channel value is
0 .. ADS1015_CHANNELS - 1.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hwmon/ads1015.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/ads1015.c b/drivers/hwmon/ads1015.c
index 7f9dc2f86b63..22e0c926989d 100644
--- a/drivers/hwmon/ads1015.c
+++ b/drivers/hwmon/ads1015.c
@@ -198,7 +198,7 @@ static int ads1015_get_channels_config_of(struct i2c_client *client)
 		}
 
 		channel = be32_to_cpup(property);
-		if (channel > ADS1015_CHANNELS) {
+		if (channel >= ADS1015_CHANNELS) {
 			dev_err(&client->dev,
 				"invalid channel index %d on %s\n",
 				channel, node->full_name);
-- 
2.1.0


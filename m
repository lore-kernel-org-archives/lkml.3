Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbaIOWL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:11:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50605 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbaIOWLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:11:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 110/187] hwmon: (ads1015) Fix off-by-one for valid channel index checking
Date: Mon, 15 Sep 2014 15:08:40 -0700
Message-Id: <1410818997-9432-111-git-send-email-kamal@canonical.com>
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

commit 56de1377ad92f72ee4e5cb0faf7a9b6048fdf0bf upstream.

Current code uses channel as array index, so the valid channel value is
0 .. ADS1015_CHANNELS - 1.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hwmon/ads1015.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/ads1015.c b/drivers/hwmon/ads1015.c
index 7f9dc2f..22e0c92 100644
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
1.9.1


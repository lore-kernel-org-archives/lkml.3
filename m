Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbaELLsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 07:48:45 -0400
Received: from we2-f167.wedos.net ([46.28.105.74]:40729 "EHLO
	we2-f167.wedos.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaELLsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 07:48:43 -0400
Date: Mon, 12 May 2014 13:48:26 +0200
From: Josef Gajdusek <atx@atx.name>
To: jdelvare@suse.de
Cc: linux@roeck-us.net, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/hwmon/emc1403.c: add new revision numbers to
 emc1403_detect()
Message-ID: <20140512114826.GA16252@dashie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds new chip revision numbers to emc1403.c. Altough the datasheet (for emc1412) does not say so directly, it seems to suggest, that chips with revision ID 0x03 exist.

Signed-off-by: Josef Gajdusek <atx@atx.name>
---
diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
index 61d89d6..b2b6a52 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -330,7 +330,7 @@ static int emc1403_detect(struct i2c_client *client,
 	}
 
 	id = i2c_smbus_read_byte_data(client, THERMAL_REVISION_REG);
-	if (id != 0x01)
+	if (id < 0x01 || id > 0x04)
 		return -ENODEV;
 
 	return 0;


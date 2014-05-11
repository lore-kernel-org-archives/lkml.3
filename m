Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbaEKMk4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 08:40:56 -0400
Received: from we2-f167.wedos.net ([46.28.105.74]:34798 "EHLO
	we2-f167.wedos.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829AbaEKMky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 08:40:54 -0400
Date: Sun, 11 May 2014 14:40:44 +0200
From: Josef Gajdusek <atx@atx.name>
To: jdelvare@suse.de
Cc: linux@roeck-us.net, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/hwmon/emc1403.c: fix inverted set_hyst()
Message-ID: <20140511124044.GA2730@dashie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes inverted set_hyst() (i. e. writing 76000 actually set it to 74000)

Signed-off-by: Josef Gajdusek <atx@atx.name>
---
diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
index 90ec117..61d89d6 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -163,7 +163,7 @@ static ssize_t store_hyst(struct device *dev,
 	if (retval < 0)
 		goto fail;
 
-	hyst = val - retval * 1000;
+	hyst = retval * 1000 - val;
 	hyst = DIV_ROUND_CLOSEST(hyst, 1000);
 	if (hyst < 0 || hyst > 255) {
 		retval = -ERANGE;

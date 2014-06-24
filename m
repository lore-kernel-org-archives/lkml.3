Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbaFXUaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:30:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47608 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbaFXUah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:30:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Gajdusek <atx@atx.name>, Guenter Roeck <linux@roeck-us.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 13/65] hwmon: (emc1403) fix inverted store_hyst()
Date: Tue, 24 Jun 2014 13:29:33 -0700
Message-Id: <1403641825-12825-14-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403641825-12825-1-git-send-email-kamal@canonical.com>
References: <1403641825-12825-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.25 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Gajdusek <atx@atx.name>

commit 17c048fc4bd95efea208a1920f169547d8588f1f upstream.

Attempts to set the hysteresis value to a temperature below the target
limit fails with "write error: Numerical result out of range" due to
an inverted comparison.

Signed-off-by: Josef Gajdusek <atx@atx.name>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
[Guenter Roeck: Updated headline and description]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hwmon/emc1403.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
index 142e1cb..62fba71 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -162,7 +162,7 @@ static ssize_t store_hyst(struct device *dev,
 	if (retval < 0)
 		goto fail;
 
-	hyst = val - retval * 1000;
+	hyst = retval * 1000 - val;
 	hyst = DIV_ROUND_CLOSEST(hyst, 1000);
 	if (hyst < 0 || hyst > 255) {
 		retval = -ERANGE;
-- 
1.9.1


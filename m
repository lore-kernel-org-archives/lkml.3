Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967568AbaFQWm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:42:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53897 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965999AbaFQVrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:47:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Gajdusek <atx@atx.name>, Guenter Roeck <linux@roeck-us.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 109/212] hwmon: (emc1403) fix inverted store_hyst()
Date: Tue, 17 Jun 2014 14:43:23 -0700
Message-Id: <1403041506-13646-110-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

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
-- 
1.9.1


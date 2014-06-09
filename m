Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903AbaFIJPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:15:09 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58409 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754836AbaFIIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Josef Gajdusek <atx@atx.name>,
        Guenter Roeck <linux@roeck-us.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 034/146] hwmon: (emc1403) fix inverted store_hyst()
Date: Mon,  9 Jun 2014 10:49:29 +0200
Message-Id: <f77cb78f4fd2951fa29bf80939ec41b3b21f9e06.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josef Gajdusek <atx@atx.name>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 17c048fc4bd95efea208a1920f169547d8588f1f upstream.

Attempts to set the hysteresis value to a temperature below the target
limit fails with "write error: Numerical result out of range" due to
an inverted comparison.

Signed-off-by: Josef Gajdusek <atx@atx.name>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
[Guenter Roeck: Updated headline and description]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hwmon/emc1403.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
index 142e1cb8dea7..62fba71ef3c5 100644
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
1.9.3


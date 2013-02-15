Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161804Ab3BONGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:06:45 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:41615 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161374Ab3BOM5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:57:33 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Marcus Cooper <marcus.xm.cooper@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/35] mfd: ab8500-core: Sysfs chip id modification
Date: Fri, 15 Feb 2013 12:56:37 +0000
Message-Id: <1360933026-30325-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcus Cooper <marcus.xm.cooper@stericsson.com>

On newer variants of the ab a version and revision value can be
read. This modification merges these two values to create a
chip id.

Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
Tested-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/mfd/ab8500-core.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 7c20728..678afd0 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1095,9 +1095,15 @@ static ssize_t show_chip_id(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct ab8500 *ab8500;
+	int chip_id = -EINVAL;
 
 	ab8500 = dev_get_drvdata(dev);
-	return sprintf(buf, "%#x\n", ab8500 ? ab8500->chip_id : -EINVAL);
+	if(ab8500) {
+		chip_id = ab8500->chip_id;
+		if((is_ab8505(ab8500) || is_ab9540(ab8500)) && ab8500->version != 0xFF)
+			chip_id = (ab8500->version << 8) | chip_id;
+	}
+	return sprintf(buf, "%#x\n", chip_id);
 }
 
 /*
-- 
1.7.10.4


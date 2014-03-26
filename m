Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbaCZURN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 16:17:13 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:62369 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030AbaCZURL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 16:17:11 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Mar 2014 16:17:11 EDT
From: Sebastien Bourdelin <sebastien.bourdelin@savoirfairelinux.com>
To: lm-sensors@lm-sensors.org
Cc: jerome.oufella@savoirfairelinux.com, linux-kernel@vger.kernel.org,
        Sebastien Bourdelin <sebastien.bourdelin@savoirfairelinux.com>
Subject: [PATCH] misc: (ds1682) replace obsolete simple_strtoull() with kstrtoull()
Date: Wed, 26 Mar 2014 16:11:04 -0400
Message-Id: <1395864664-16404-1-git-send-email-sebastien.bourdelin@savoirfairelinux.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

simple_strtoull() is obsolete, use the newer kstrtoull() instead.

Signed-off-by: Sebastien Bourdelin <sebastien.bourdelin@savoirfairelinux.com>
---
 drivers/misc/ds1682.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/ds1682.c b/drivers/misc/ds1682.c
index 154b02e..155a150 100644
--- a/drivers/misc/ds1682.c
+++ b/drivers/misc/ds1682.c
@@ -86,7 +86,6 @@ static ssize_t ds1682_store(struct device *dev, struct device_attribute *attr,
 {
 	struct sensor_device_attribute_2 *sattr = to_sensor_dev_attr_2(attr);
 	struct i2c_client *client = to_i2c_client(dev);
-	char *endp;
 	u64 val;
 	__le32 val_le;
 	int rc;
@@ -94,8 +93,8 @@ static ssize_t ds1682_store(struct device *dev, struct device_attribute *attr,
 	dev_dbg(dev, "ds1682_store() called on %s\n", attr->attr.name);
 
 	/* Decode input */
-	val = simple_strtoull(buf, &endp, 0);
-	if (buf == endp) {
+	rc = kstrtoull(buf, 0, &val);
+	if (rc < 0) {
 		dev_dbg(dev, "input string not a number\n");
 		return -EINVAL;
 	}
-- 
1.9.1


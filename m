Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaBKQI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:08:59 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:32448 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaBKQI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:08:58 -0500
Date: Tue, 11 Feb 2014 19:08:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Evgeniy Polyakov <zbr@ioremap.net>, David Fries <David@Fries.net>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] w1: small type cleanup in sysfs
Message-ID: <20140211160826.GD9406@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 64 bit systems, a large value for "tmp" could be truncated so we
still end up with a ->max_slave_count which is less than one despite the
"tmp < 1" check.

This is more of a problem for static checkers than a real life issue,
but it's simple enough to fix.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 9eb816b2ea5e..b96f61b15dc6 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -320,10 +320,10 @@ static ssize_t w1_master_attribute_show_timeout(struct device *dev, struct devic
 static ssize_t w1_master_attribute_store_max_slave_count(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
-	long tmp;
+	int tmp;
 	struct w1_master *md = dev_to_w1_master(dev);
 
-	if (kstrtol(buf, 0, &tmp) == -EINVAL || tmp < 1)
+	if (kstrtoint(buf, 0, &tmp) == -EINVAL || tmp < 1)
 		return -EINVAL;
 
 	mutex_lock(&md->mutex);

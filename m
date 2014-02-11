Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbaBKVI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:08:28 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:32116 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbaBKVIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:08:24 -0500
Date: Wed, 12 Feb 2014 00:07:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Evgeniy Polyakov <zbr@ioremap.net>, David Fries <David@Fries.net>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v2] w1: small type cleanup in sysfs
Message-ID: <20140211210755.GA25579@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211164513.GF5530@spacedout.fries.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 64 bit systems, a large value for "long tmp" is truncated when
assigning to "int md->max_slave_count" so we still end up with a value
less than one despite the "tmp < 1" check.

This is more of a problem for static checkers than a real life issue,
but it's simple enough to fix.

Acked-by: David Fries <david@fries.net>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: clarified the commit message

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


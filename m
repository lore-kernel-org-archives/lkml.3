Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaDVEAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 00:00:22 -0400
Received: from ozlabs.org ([103.22.144.67]:40084 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbaDVD7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:59:10 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/9] drivers/regulator/virtual: avoid world-writable sysfs files.
Date: Tue, 22 Apr 2014 13:03:28 +0930
Message-Id: <1398137612-9714-6-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
References: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In line with practice for module parameters, we're adding a build-time
check that sysfs files aren't world-writable.

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/regulator/virtual.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/virtual.c b/drivers/regulator/virtual.c
index f53e78b9a84e..6ff95b045984 100644
--- a/drivers/regulator/virtual.c
+++ b/drivers/regulator/virtual.c
@@ -266,11 +266,11 @@ static ssize_t set_mode(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
-static DEVICE_ATTR(min_microvolts, 0666, show_min_uV, set_min_uV);
-static DEVICE_ATTR(max_microvolts, 0666, show_max_uV, set_max_uV);
-static DEVICE_ATTR(min_microamps, 0666, show_min_uA, set_min_uA);
-static DEVICE_ATTR(max_microamps, 0666, show_max_uA, set_max_uA);
-static DEVICE_ATTR(mode, 0666, show_mode, set_mode);
+static DEVICE_ATTR(min_microvolts, 0664, show_min_uV, set_min_uV);
+static DEVICE_ATTR(max_microvolts, 0664, show_max_uV, set_max_uV);
+static DEVICE_ATTR(min_microamps, 0664, show_min_uA, set_min_uA);
+static DEVICE_ATTR(max_microamps, 0664, show_max_uA, set_max_uA);
+static DEVICE_ATTR(mode, 0664, show_mode, set_mode);
 
 static struct attribute *regulator_virtual_attributes[] = {
 	&dev_attr_min_microvolts.attr,
-- 
1.8.3.2


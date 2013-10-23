Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab3JWLkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:40:10 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:44315 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab3JWLkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:40:08 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] PowerCap: Convert class code to use dev_groups
Date: Wed, 23 Oct 2013 13:37:35 +0200
Message-Id: <1382528255-12781-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newly added power capping framework uses the obsolete .dev_attrs
field of struct class. However this field will be removed in 3.13, so
convert the code to use the .dev_groups field instead.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Compile-tested only.
---
 drivers/powercap/powercap_sys.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/powercap/powercap_sys.c b/drivers/powercap/powercap_sys.c
index c22fa4c..21814f9 100644
--- a/drivers/powercap/powercap_sys.c
+++ b/drivers/powercap/powercap_sys.c
@@ -472,16 +472,18 @@ static ssize_t enabled_store(struct device *dev,
 	return -ENOSYS;
 }
 
-static struct device_attribute powercap_def_attrs[] = {
-		__ATTR(enabled, S_IWUSR | S_IRUGO, enabled_show,
-							enabled_store),
-		__ATTR_NULL
+static DEVICE_ATTR_RW(enabled);
+
+static struct attribute *powercap_attrs[] = {
+	&dev_attr_enabled.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(powercap);
 
 static struct class powercap_class = {
 	.name = "powercap",
 	.dev_release = powercap_release,
-	.dev_attrs = powercap_def_attrs,
+	.dev_groups = powercap_groups,
 };
 
 struct powercap_zone *powercap_register_zone(
-- 
1.8.4


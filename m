Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaILXHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 19:07:40 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:52235 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaILXHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 19:07:12 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/13] eeepc-laptop: use DEVICE_ATTR to instantiate device_attributes
Date: Sat, 13 Sep 2014 01:06:44 +0200
Message-Id: <1410563212-31565-6-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
References: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c | 35 +++++------------------------------
 1 file changed, 5 insertions(+), 30 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index f35d008..8225b1e 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -308,13 +308,7 @@ static ssize_t show_sys_acpi(struct device *dev, int cm, char *buf)
 	{								\
 		return store_sys_acpi(dev, _cm, buf, count);		\
 	}								\
-	static struct device_attribute dev_attr_##_name = {		\
-		.attr = {						\
-			.name = __stringify(_name),			\
-			.mode = _mode },				\
-		.show   = show_##_name,					\
-		.store  = store_##_name,				\
-	}
+	static DEVICE_ATTR(_name, _mode, show_##_name, store_##_name)
 
 EEEPC_CREATE_DEVICE_ATTR(camera, S_IWUSR | S_IRUGO, CM_ASL_CAMERA);
 EEEPC_CREATE_DEVICE_ATTR(cardr, S_IWUSR | S_IRUGO, CM_ASL_CARDREADER);
@@ -420,29 +414,10 @@ static ssize_t store_cpufv_disabled(struct device *dev,
 }
 
 
-static struct device_attribute dev_attr_cpufv = {
-	.attr = {
-		.name = "cpufv",
-		.mode = S_IWUSR | S_IRUGO },
-	.show   = show_cpufv,
-	.store  = store_cpufv
-};
-
-static struct device_attribute dev_attr_available_cpufv = {
-	.attr = {
-		.name = "available_cpufv",
-		.mode = S_IRUGO },
-	.show   = show_available_cpufv
-};
-
-static struct device_attribute dev_attr_cpufv_disabled = {
-	.attr = {
-		.name = "cpufv_disabled",
-		.mode = S_IWUSR | S_IRUGO},
-	.show   = show_cpufv_disabled,
-	.store  = store_cpufv_disabled
-};
-
+static DEVICE_ATTR(cpufv, S_IWUSR | S_IRUGO, show_cpufv, store_cpufv);
+static DEVICE_ATTR(available_cpufv, S_IRUGO, show_available_cpufv, NULL);
+static DEVICE_ATTR(cpufv_disabled, S_IWUSR | S_IRUGO,
+		   show_cpufv_disabled, store_cpufv_disabled);
 
 static struct attribute *platform_attributes[] = {
 	&dev_attr_camera.attr,
-- 
2.1.0


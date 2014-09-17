Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbaIQVuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:50:24 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:58803 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906AbaIQVsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:48:25 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] eeepc-laptop: use DEVICE_ATTR* to instantiate device_attributes
Date: Wed, 17 Sep 2014 23:47:21 +0200
Message-Id: <1410990447-3210-4-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410990447-3210-1-git-send-email-fransklaver@gmail.com>
References: <1410990447-3210-1-git-send-email-fransklaver@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device attributes are instantiated manually, while we have DEVICE_ATTR*
macros available to do much of the work for us. Let's use them.

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c | 34 ++++------------------------------
 1 file changed, 4 insertions(+), 30 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 0094449..db26f78 100644
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
-		.show   = _name##_show,					\
-		.store  = _name##_store,				\
-	}
+	static DEVICE_ATTR(_name, _mode, _name##_show, _name##_store)
 
 EEEPC_CREATE_DEVICE_ATTR(camera, 0644, CM_ASL_CAMERA);
 EEEPC_CREATE_DEVICE_ATTR(cardr, 0644, CM_ASL_CARDREADER);
@@ -420,29 +414,9 @@ static ssize_t cpufv_disabled_store(struct device *dev,
 }
 
 
-static struct device_attribute dev_attr_cpufv = {
-	.attr = {
-		.name = "cpufv",
-		.mode = 0644 },
-	.show   = cpufv_show,
-	.store  = cpufv_store
-};
-
-static struct device_attribute dev_attr_available_cpufv = {
-	.attr = {
-		.name = "available_cpufv",
-		.mode = 0444 },
-	.show   = available_cpufv_show
-};
-
-static struct device_attribute dev_attr_cpufv_disabled = {
-	.attr = {
-		.name = "cpufv_disabled",
-		.mode = 0644 },
-	.show   = cpufv_disabled_show,
-	.store  = cpufv_disabled_store
-};
-
+static DEVICE_ATTR_RW(cpufv);
+static DEVICE_ATTR_RO(available_cpufv);
+static DEVICE_ATTR_RW(cpufv_disabled);
 
 static struct attribute *platform_attributes[] = {
 	&dev_attr_camera.attr,
-- 
2.1.0


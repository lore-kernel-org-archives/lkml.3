Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaILXLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 19:11:22 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:43804 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaILXHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 19:07:10 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/13] eeepc-laptop: use symbolic permissions in device attributes
Date: Sat, 13 Sep 2014 01:06:43 +0200
Message-Id: <1410563212-31565-5-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
References: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 9d8dff9..f35d008 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -316,9 +316,9 @@ static ssize_t show_sys_acpi(struct device *dev, int cm, char *buf)
 		.store  = store_##_name,				\
 	}
 
-EEEPC_CREATE_DEVICE_ATTR(camera, 0644, CM_ASL_CAMERA);
-EEEPC_CREATE_DEVICE_ATTR(cardr, 0644, CM_ASL_CARDREADER);
-EEEPC_CREATE_DEVICE_ATTR(disp, 0200, CM_ASL_DISPLAYSWITCH);
+EEEPC_CREATE_DEVICE_ATTR(camera, S_IWUSR | S_IRUGO, CM_ASL_CAMERA);
+EEEPC_CREATE_DEVICE_ATTR(cardr, S_IWUSR | S_IRUGO, CM_ASL_CARDREADER);
+EEEPC_CREATE_DEVICE_ATTR(disp, S_IWUSR, CM_ASL_DISPLAYSWITCH);
 
 struct eeepc_cpufv {
 	int num;
@@ -423,7 +423,7 @@ static ssize_t store_cpufv_disabled(struct device *dev,
 static struct device_attribute dev_attr_cpufv = {
 	.attr = {
 		.name = "cpufv",
-		.mode = 0644 },
+		.mode = S_IWUSR | S_IRUGO },
 	.show   = show_cpufv,
 	.store  = store_cpufv
 };
@@ -431,14 +431,14 @@ static struct device_attribute dev_attr_cpufv = {
 static struct device_attribute dev_attr_available_cpufv = {
 	.attr = {
 		.name = "available_cpufv",
-		.mode = 0444 },
+		.mode = S_IRUGO },
 	.show   = show_available_cpufv
 };
 
 static struct device_attribute dev_attr_cpufv_disabled = {
 	.attr = {
 		.name = "cpufv_disabled",
-		.mode = 0644 },
+		.mode = S_IWUSR | S_IRUGO},
 	.show   = show_cpufv_disabled,
 	.store  = store_cpufv_disabled
 };
-- 
2.1.0


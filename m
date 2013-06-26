Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab3FZQdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:33:51 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:34069 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab3FZQdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:33:50 -0400
From: Jiang Liu <liuj97@gmail.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: [PATCH v2 3/9] ACPI, DOCK: mark initialization functions with __init
Date: Thu, 27 Jun 2013 00:30:55 +0800
Message-Id: <1372264261-17442-4-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372264261-17442-1-git-send-email-liuj97@gmail.com>
References: <1372264261-17442-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Mark all initialization functions with __init to reduce runtime memory
consumption.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/acpi/dock.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index a73571f..8c4214d 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -100,7 +100,7 @@ struct dock_dependent_device {
  *
  * Add the dependent device to the dock's dependent device list.
  */
-static int
+static int __init
 add_dock_dependent_device(struct dock_station *ds, acpi_handle handle)
 {
 	struct dock_dependent_device *dd;
@@ -244,7 +244,7 @@ static int is_dock(acpi_handle handle)
 	return 1;
 }
 
-static int is_ejectable(acpi_handle handle)
+static int __init is_ejectable(acpi_handle handle)
 {
 	acpi_status status;
 	acpi_handle tmp;
@@ -255,7 +255,7 @@ static int is_ejectable(acpi_handle handle)
 	return 1;
 }
 
-static int is_ata(acpi_handle handle)
+static int __init is_ata(acpi_handle handle)
 {
 	acpi_handle tmp;
 
@@ -268,7 +268,7 @@ static int is_ata(acpi_handle handle)
 	return 0;
 }
 
-static int is_battery(acpi_handle handle)
+static int __init is_battery(acpi_handle handle)
 {
 	struct acpi_device_info *info;
 	int ret = 1;
@@ -284,7 +284,7 @@ static int is_battery(acpi_handle handle)
 	return ret;
 }
 
-static int is_ejectable_bay(acpi_handle handle)
+static int __init is_ejectable_bay(acpi_handle handle)
 {
 	acpi_handle phandle;
 
@@ -848,7 +848,7 @@ static struct notifier_block dock_acpi_notifier = {
  * check to see if an object has an _EJD method.  If it does, then it
  * will see if it is dependent on the dock station.
  */
-static acpi_status
+static acpi_status __init
 find_dock_devices(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
 	acpi_status status;
-- 
1.8.1.2


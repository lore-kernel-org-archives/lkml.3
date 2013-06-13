Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794Ab3FMQfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:35:48 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:36405 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758736Ab3FMQfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:35:45 -0400
From: Jiang Liu <jiang.liu@huawei.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shaohua Li <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: [BUGFIX 6/9] ACPI, DOCK: mark initialization functions with __init
Date: Fri, 14 Jun 2013 00:32:29 +0800
Message-Id: <1371141152-9468-7-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark all initialization functions with __init to reduce memory
consumption at runtime.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/acpi/dock.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index cd2d5df..da3314d 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -94,7 +94,7 @@ struct dock_dependent_device {
  *
  * Add the dependent device to the dock's dependent device list.
  */
-static int
+static int __init
 add_dock_dependent_device(struct dock_station *ds, acpi_handle handle)
 {
 	struct dock_dependent_device *dd;
@@ -192,7 +192,7 @@ static int is_dock(acpi_handle handle)
 	return 1;
 }
 
-static int is_ejectable(acpi_handle handle)
+static int __init is_ejectable(acpi_handle handle)
 {
 	acpi_status status;
 	acpi_handle tmp;
@@ -203,7 +203,7 @@ static int is_ejectable(acpi_handle handle)
 	return 1;
 }
 
-static int is_ata(acpi_handle handle)
+static int __init is_ata(acpi_handle handle)
 {
 	acpi_handle tmp;
 
@@ -216,7 +216,7 @@ static int is_ata(acpi_handle handle)
 	return 0;
 }
 
-static int is_battery(acpi_handle handle)
+static int __init is_battery(acpi_handle handle)
 {
 	struct acpi_device_info *info;
 	int ret = 1;
@@ -232,7 +232,7 @@ static int is_battery(acpi_handle handle)
 	return ret;
 }
 
-static int is_ejectable_bay(acpi_handle handle)
+static int __init is_ejectable_bay(acpi_handle handle)
 {
 	acpi_handle phandle;
 
@@ -809,7 +809,7 @@ static struct notifier_block dock_acpi_notifier = {
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab3FMQgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:36:00 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:54206 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758690Ab3FMQf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:35:57 -0400
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
Subject: [BUGFIX 7/9] ACPI, DOCK: simplify implementation of dock_create_acpi_device()
Date: Fri, 14 Jun 2013 00:32:30 +0800
Message-Id: <1371141152-9468-8-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of dock_create_acpi_device() is unused, so simplify
it by returning void.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/acpi/dock.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index da3314d..72cf97e 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -299,10 +299,8 @@ static int dock_present(struct dock_station *ds)
  *  handle if one does not exist already.  This should cause
  *  acpi to scan for drivers for the given devices, and call
  *  matching driver's add routine.
- *
- *  Returns a pointer to the acpi_device corresponding to the handle.
  */
-static struct acpi_device * dock_create_acpi_device(acpi_handle handle)
+static void dock_create_acpi_device(acpi_handle handle)
 {
 	struct acpi_device *device;
 	int ret;
@@ -315,10 +313,7 @@ static struct acpi_device * dock_create_acpi_device(acpi_handle handle)
 		ret = acpi_bus_scan(handle);
 		if (ret)
 			pr_debug("error adding bus, %x\n", -ret);
-
-		acpi_bus_get_device(handle, &device);
 	}
-	return device;
 }
 
 /**
-- 
1.8.1.2


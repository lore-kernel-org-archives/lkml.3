Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726Ab3FMQfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:35:39 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:51038 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758658Ab3FMQfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:35:36 -0400
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
Subject: [BUGFIX 4/9] ACPI, DOCK: avoid initializing acpi_dock_notifier_list multiple times
Date: Fri, 14 Jun 2013 00:32:27 +0800
Message-Id: <1371141152-9468-5-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize acpi_dock_notifier_list from function acpi_dock_init()
instead of dock_add() to avoid initializing it multiple times.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/acpi/dock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 50e38b7..8e578aa 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -967,7 +967,6 @@ static int __init dock_add(acpi_handle handle)
 	spin_lock_init(&dock_station->dd_lock);
 	INIT_LIST_HEAD(&dock_station->sibling);
 	INIT_LIST_HEAD(&dock_station->hotplug_devices);
-	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);
 	INIT_LIST_HEAD(&dock_station->dependent_devices);
 
 	/* we want the dock device to send uevents */
@@ -1038,6 +1037,7 @@ int __init acpi_dock_init(void)
 		return 0;
 	}
 
+	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);
 	register_acpi_bus_notifier(&dock_acpi_notifier);
 	pr_info(PREFIX "%s: %d docks/bays found\n",
 		ACPI_DOCK_DRIVER_DESCRIPTION, dock_station_count);
-- 
1.8.1.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab3F1Q1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:27:09 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:37042 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab3F1Q1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:27:07 -0400
From: Jiang Liu <liuj97@gmail.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: [PATCH v3 01/10] ACPI, DOCK: avoid initializing acpi_dock_notifier_list multiple times
Date: Sat, 29 Jun 2013 00:24:34 +0800
Message-Id: <1372436683-31711-2-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372436683-31711-1-git-send-email-liuj97@gmail.com>
References: <1372436683-31711-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Function dock_add() will be called multiple times if there are multiple
dock stations, which causes acpi_dock_notifier_list being initialized
multiple times. So move initialization of acpi_dock_notifier_list from
dock_add() to acpi_dock_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/acpi/dock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 14de9f4..e944e39 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -1007,7 +1007,6 @@ static int __init dock_add(acpi_handle handle)
 	mutex_init(&dock_station->hp_lock);
 	spin_lock_init(&dock_station->dd_lock);
 	INIT_LIST_HEAD(&dock_station->sibling);
-	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);
 	INIT_LIST_HEAD(&dock_station->dependent_devices);
 
 	/* we want the dock device to send uevents */
@@ -1078,6 +1077,7 @@ int __init acpi_dock_init(void)
 		return 0;
 	}
 
+	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);
 	register_acpi_bus_notifier(&dock_acpi_notifier);
 	pr_info(PREFIX "%s: %d docks/bays found\n",
 		ACPI_DOCK_DRIVER_DESCRIPTION, dock_station_count);
-- 
1.8.1.2


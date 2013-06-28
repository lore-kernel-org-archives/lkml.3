Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3F1Q33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:29:29 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:56746 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab3F1Q1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:27:19 -0400
From: Jiang Liu <liuj97@gmail.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: [PATCH v3 04/10] ACPI, DOCK: simplify implementation of dock_create_acpi_device()
Date: Sat, 29 Jun 2013 00:24:37 +0800
Message-Id: <1372436683-31711-5-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372436683-31711-1-git-send-email-liuj97@gmail.com>
References: <1372436683-31711-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

The return value of dock_create_acpi_device() is not used at all,
so change the signature to return void and simplify implementation.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/acpi/dock.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 8c4214d..22183c4 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -351,10 +351,8 @@ static int dock_present(struct dock_station *ds)
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
@@ -367,10 +365,7 @@ static struct acpi_device * dock_create_acpi_device(acpi_handle handle)
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


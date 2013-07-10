Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab3GJQr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 12:47:59 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:30612 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab3GJQr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 12:47:57 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: rjw@sisk.pl
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] ACPI / memhotplug: Fix a stale pointer in error path
Date: Wed, 10 Jul 2013 10:47:13 -0600
Message-Id: <1373474833-14047-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device->driver_data needs to be cleared when releasing its data,
mem_device, in an error path of acpi_memory_device_add().

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/acpi_memhotplug.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index c711d11..999adb5 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -323,6 +323,7 @@ static int acpi_memory_device_add(struct acpi_device *device,
 	/* Get the range from the _CRS */
 	result = acpi_memory_get_device_resources(mem_device);
 	if (result) {
+		device->driver_data = NULL;
 		kfree(mem_device);
 		return result;
 	}

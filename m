Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab3JBI2C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 04:28:02 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:52431 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab3JBI16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 04:27:58 -0400
Message-ID: <524BD8F9.2000304@gmail.com>
Date: Wed, 02 Oct 2013 16:27:37 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: lenb@kernel.org, "Rafael J . Wysocki" <rjw@sisk.pl>
CC: linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] acpi/mem_hotplug: Use defined marco METHOD_NAME__STA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

We already have predefined marco for method name "_STA', so
using the marco instead of directly using the string.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 drivers/acpi/acpi_memhotplug.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 999adb5..dc0880d 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -152,8 +152,9 @@ static int acpi_memory_check_device(struct acpi_memory_device *mem_device)
 	unsigned long long current_status;
 
 	/* Get device present/absent information from the _STA */
-	if (ACPI_FAILURE(acpi_evaluate_integer(mem_device->device->handle, "_STA",
-					       NULL, &current_status)))
+	if (ACPI_FAILURE(acpi_evaluate_integer(mem_device->device->handle,
+					       METHOD_NAME__STA, NULL,
+					       &current_status)))
 		return -ENODEV;
 	/*
 	 * Check for device status. Device should be
-- 
1.7.1

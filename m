Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab3J1GFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 02:05:18 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:50432 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab3J1GE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 02:04:59 -0400
From: RUC_SoftSec <rucsoftsec@gmail.com>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        RUC_SoftSec <rucsoftsec@gmail.com>
Subject: [PATCH 1/1] acpi: check return value of acpi_os_map_memory
Date: Mon, 28 Oct 2013 14:04:19 +0800
Message-Id: <1382940259-15183-1-git-send-email-rucsoftsec@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function acpi_os_map_memory() may return a NULL pointer, it should be validated non-NULL before used.
This bug is found by a static tool developed by RUC_SoftSec, supported by China.X.Orion.

Signed-off-by: RUC_SoftSec <rucsoftsec@gmail.com>
---
 drivers/acpi/osl.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index e5f416c..bf8f93f 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -717,6 +717,8 @@ acpi_os_physical_table_override(struct acpi_table_header *existing_table,
 
 		table = acpi_os_map_memory(acpi_tables_addr + table_offset,
 					   ACPI_HEADER_SIZE);
+		if (table == NULL)
+			return AE_OK;
 
 		if (table_offset + table->length > all_tables_size) {
 			acpi_os_unmap_memory(table, ACPI_HEADER_SIZE);
-- 
1.7.9.5


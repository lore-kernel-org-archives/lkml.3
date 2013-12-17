Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3LQJLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:11:37 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46610 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab3LQJLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:11:34 -0500
Date: Tue, 17 Dec 2013 14:41:25 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 01/11] drivers: acpi: Mark the function acpi_table_checksum()
 as static in osl.c
Message-ID: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marks the function acpi_table_checksum() as static in osl.c
because it is not used outside this file.

This eliminates the following warning in osl.c:
drivers/acpi/osl.c:547:11: warning: no previous prototype for ‘acpi_table_checksum’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/acpi/osl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 54a20ff..1f4c104 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -544,7 +544,7 @@ static u64 acpi_tables_addr;
 static int all_tables_size;
 
 /* Copied from acpica/tbutils.c:acpi_tb_checksum() */
-u8 __init acpi_table_checksum(u8 *buffer, u32 length)
+static u8 __init acpi_table_checksum(u8 *buffer, u32 length)
 {
 	u8 sum = 0;
 	u8 *end = buffer + length;
-- 
1.7.9.5


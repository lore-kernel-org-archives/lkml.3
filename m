Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab3GJS3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 14:29:37 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:61388 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3GJS3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:29:36 -0400
Message-ID: <51DDA7FB.1000801@gmail.com>
Date: Thu, 11 Jul 2013 02:29:15 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: rjw@sisk.pl, lenb@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI: Use early_memremap() instead of early_ioremap()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

The mapping of acpi_tables_addr is obviously ordinary memory, so
use early_memremap() rather than early_iormeap().

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 drivers/acpi/osl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 6ab2c35..8961e6e 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -644,7 +644,7 @@ void __init acpi_initrd_override(void *data, size_t size)
 	memblock_reserve(acpi_tables_addr, all_tables_size);
 	arch_reserve_mem_area(acpi_tables_addr, all_tables_size);
 
-	p = early_ioremap(acpi_tables_addr, all_tables_size);
+	p = early_memremap(acpi_tables_addr, all_tables_size);
 
 	for (no = 0; no < table_nr; no++) {
 		memcpy(p + total_offset, early_initrd_files[no].data,
-- 
1.7.1

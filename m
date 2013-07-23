Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab3GWNDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 09:03:34 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:34642 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159Ab3GWNDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 09:03:33 -0400
Message-ID: <51EE7F1C.9020506@gmail.com>
Date: Tue, 23 Jul 2013 21:03:24 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, len.brown@intel.com, pavel@ucw.cz,
        rjw@sisk.pl
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] x86, acpi: Correct out-of-date comment of __acpi_map_table
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

The implementation of function __acpi_map_table() has been changed
long time ago, and now it directly invokes early_ioremap() to setup
the temporarily acpi table mappings. So correct its out-of-date
comment.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
-v2: Replace the comment with a simple correct one instead of removing
     it -- suggested by Ingo
---
 arch/x86/kernel/acpi/boot.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 2627a81..c7f61cf 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -141,16 +141,8 @@ static u32 irq_to_gsi(int irq)
 }
 
 /*
- * Temporarily use the virtual area starting from FIX_IO_APIC_BASE_END,
- * to map the target physical address. The problem is that set_fixmap()
- * provides a single page, and it is possible that the page is not
- * sufficient.
- * By using this area, we can map up to MAX_IO_APICS pages temporarily,
- * i.e. until the next __va_range() call.
- *
- * Important Safety Note:  The fixed I/O APIC page numbers are *subtracted*
- * from the fixed base.  That's why we start at FIX_IO_APIC_BASE_END and
- * count idx down while incrementing the phys address.
+ * This is just a simple wrapper around early_ioremap(),
+ * with sanity checks for phys == 0 and size == 0.
  */
 char *__init __acpi_map_table(unsigned long phys, unsigned long size)
 {
@@ -160,6 +152,7 @@ char *__init __acpi_map_table(unsigned long phys, unsigned long size)
 
 	return early_ioremap(phys, size);
 }
+
 void __init __acpi_unmap_table(char *map, unsigned long size)
 {
 	if (!map || !size)
-- 
1.7.1

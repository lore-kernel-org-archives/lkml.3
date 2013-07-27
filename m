Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268Ab3G0J6x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 05:58:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57845 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3G0J6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 05:58:49 -0400
Date: Sat, 27 Jul 2013 02:58:20 -0700
From: tip-bot for Zhang Yanfei <tipbot@zytor.com>
Message-ID: <tip-45f1330af6819b348fbac89e69d59d8129d61960@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        zhangyanfei@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, tglx@linutronix.de
In-Reply-To: <51EE7F1C.9020506@gmail.com>
References: <51EE7F1C.9020506@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/acpi:
  Correct out-of-date comment of __acpi_map_table()
Git-Commit-ID: 45f1330af6819b348fbac89e69d59d8129d61960
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 27 Jul 2013 02:58:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45f1330af6819b348fbac89e69d59d8129d61960
Gitweb:     http://git.kernel.org/tip/45f1330af6819b348fbac89e69d59d8129d61960
Author:     Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
AuthorDate: Tue, 23 Jul 2013 21:03:24 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 26 Jul 2013 22:12:36 +0200

x86/acpi: Correct out-of-date comment of __acpi_map_table()

The implementation of function __acpi_map_table() has been
changed long time ago, and now it directly invokes
early_ioremap() to setup the temporarily acpi table mappings.

So correct its out-of-date comment.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: len.brown@intel.com
Cc: pavel@ucw.cz
Cc: rjw@sisk.pl
Link: http://lkml.kernel.org/r/51EE7F1C.9020506@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/acpi/boot.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

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

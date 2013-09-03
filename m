Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab3ICS7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 14:59:55 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:61162 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760523Ab3ICS7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 14:59:51 -0400
Date: Tue, 3 Sep 2013 20:59:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/platform change for v3.12
Message-ID: <20130903185948.GA32696@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-platform-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-platform-for-linus

   HEAD: 45f1330af6819b348fbac89e69d59d8129d61960 x86/acpi: Correct out-of-date comment of __acpi_map_table()

A small documentation fix.

 Thanks,

	Ingo

------------------>
Zhang Yanfei (1):
      x86/acpi: Correct out-of-date comment of __acpi_map_table()


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

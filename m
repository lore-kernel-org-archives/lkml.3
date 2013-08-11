Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab3HKA4K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 20:56:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:12251 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab3HKA4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 20:56:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,853,1367996400"; 
   d="scan'208";a="344542654"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        Joe Mario <jmario@redhat.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/3] kbuild: Increase kallsyms max symbol length
Date: Sat, 10 Aug 2013 17:55:31 -0700
Message-Id: <1376182533-17530-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Mario <jmario@redhat.com>

[AK: This seems like a ticking time bomb even without LTO,
so should be merged now. It causes very weird problems.
Thanks to Joe for tracking them down.]

With the added postfixes that LTO adds for local
symbols, the longest name in the kernel overflows
the namebuf[KSYM_NAME_LEN] array by two bytes.  That name is:
__pci_fixup_resumePCI_VENDOR_ID_SERVERWORKSPCI_DEVICE_ID_SERVERWORKS_HT1000SBquirk_disable_broadcom_boot_interrupt.1488004.672802

Double the max symbol name length.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/kallsyms.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 6883e19..711a50f 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -9,7 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/stddef.h>
 
-#define KSYM_NAME_LEN 128
+#define KSYM_NAME_LEN 256
 #define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + (KSYM_NAME_LEN - 1) + \
 			 2*(BITS_PER_LONG*3/10) + (MODULE_NAME_LEN - 1) + 1)
 
-- 
1.8.3.1


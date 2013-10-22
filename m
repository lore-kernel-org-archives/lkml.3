Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3JVPqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:46:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:12944 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326Ab3JVPq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:46:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="311149815"
From: Andi Kleen <andi@firstfloor.org>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Mario <jmario@redhat.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/3] kbuild: Increase kallsyms max symbol length
Date: Tue, 22 Oct 2013 08:46:21 -0700
Message-Id: <1382456783-22826-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382456783-22826-1-git-send-email-andi@firstfloor.org>
References: <1382456783-22826-1-git-send-email-andi@firstfloor.org>
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


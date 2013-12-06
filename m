Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab3LFIwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:52:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:64965 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757154Ab3LFIwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:52:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,839,1378882800"; 
   d="scan'208";a="445648703"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>, Feng Tang <feng.tang@intel.com>,
        sfi-devel@simplefirmware.org
Subject: [PATCH v3 3/6] SFI: Fix warnings reported by W=1 builds.
Date: Fri,  6 Dec 2013 16:51:59 +0800
Message-Id: <a173e089c58a7c861d5da203773078b760b5777b.1386316208.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1386316208.git.lv.zheng@intel.com>
References: <cover.1385094640.git.lv.zheng@intel.com> <cover.1386316208.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings can be seen for W=1 builds.  This is because
original sfi_acpi.[ch] header inclusions are wrong.

include/linux/sfi_acpi.h:72:2: error: implicit declaration of function 'acpi_table_parse' [-Werror=implicit-function-declaration]
drivers/sfi/sfi_acpi.c:154:5: warning: no previous prototype for 'sfi_acpi_table_parse' [-Wmissing-prototypes]

This patch fixes this existing issue.  It is on top of the following
commit which doesn't take care about existing issues:
 Commit: 4e8fb7987f7d0390a2e74622c7c1cbb6760c6516
 From: Lv Zheng <lv.zheng@intel.com>
 Date: Tue, 3 Dec 2013 08:49:16 +0800
 Subject: [PATCH] ACPI: Clean up inclusions of ACPI header files

Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Feng Tang <feng.tang@intel.com>
Cc: sfi-devel@simplefirmware.org
---
 arch/x86/pci/mmconfig-shared.c |    1 -
 drivers/sfi/sfi_acpi.c         |    4 +---
 include/linux/sfi_acpi.h       |    3 +++
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 082e881..248642f 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -12,7 +12,6 @@
 
 #include <linux/pci.h>
 #include <linux/init.h>
-#include <linux/acpi.h>
 #include <linux/sfi_acpi.h>
 #include <linux/bitmap.h>
 #include <linux/dmi.h>
diff --git a/drivers/sfi/sfi_acpi.c b/drivers/sfi/sfi_acpi.c
index 5e753d7..d277b36 100644
--- a/drivers/sfi/sfi_acpi.c
+++ b/drivers/sfi/sfi_acpi.c
@@ -60,9 +60,7 @@
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
 #include <linux/kernel.h>
-#include <acpi/acpi.h>	/* FIXME: inclusion should be removed */
-
-#include <linux/sfi.h>
+#include <linux/sfi_acpi.h>
 #include "sfi_core.h"
 
 /*
diff --git a/include/linux/sfi_acpi.h b/include/linux/sfi_acpi.h
index 2cfcb79..4723bbf 100644
--- a/include/linux/sfi_acpi.h
+++ b/include/linux/sfi_acpi.h
@@ -59,6 +59,9 @@
 #ifndef _LINUX_SFI_ACPI_H
 #define _LINUX_SFI_ACPI_H
 
+#include <linux/acpi.h>
+#include <linux/sfi.h>
+
 #ifdef CONFIG_SFI
 #include <acpi/acpi.h>	/* FIXME: inclusion should be removed */
 
-- 
1.7.10


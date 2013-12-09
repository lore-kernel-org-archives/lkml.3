Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab3LIJJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:09:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:23421 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932730Ab3LIJJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:09:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,856,1378882800"; 
   d="scan'208";a="421550951"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-acpi @ vger . kernel . org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "Zheng, Lv" <lv.zheng@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2] SFI: fix compilation warnings
Date: Mon,  9 Dec 2013 11:09:21 +0200
Message-Id: <1386580161-27718-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.4.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When build kernel with make W=1 we get the following compiler error.

In file included from drivers/sfi/sfi_acpi.c:66:0:
include/linux/sfi_acpi.h: In function ‘acpi_sfi_table_parse’:
include/linux/sfi_acpi.h:72:2: error: implicit declaration of function ‘acpi_table_parse’ [-Werror=implicit-function-declaration]
  if (!acpi_table_parse(signature, handler))
  ^
  cc1: some warnings being treated as errors

The patch add linux/acpi.h to the top of file.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
Changes to v2:
- fix for build when ACPI=n, SFI=y
 drivers/sfi/sfi_acpi.c   | 2 +-
 include/linux/sfi_acpi.h | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/sfi/sfi_acpi.c b/drivers/sfi/sfi_acpi.c
index 5e753d7..5589ec5 100644
--- a/drivers/sfi/sfi_acpi.c
+++ b/drivers/sfi/sfi_acpi.c
@@ -60,7 +60,7 @@
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
 #include <linux/kernel.h>
-#include <acpi/acpi.h>	/* FIXME: inclusion should be removed */
+#include <linux/acpi.h>
 
 #include <linux/sfi.h>
 #include "sfi_core.h"
diff --git a/include/linux/sfi_acpi.h b/include/linux/sfi_acpi.h
index 2cfcb79..ecc2344 100644
--- a/include/linux/sfi_acpi.h
+++ b/include/linux/sfi_acpi.h
@@ -60,7 +60,9 @@
 #define _LINUX_SFI_ACPI_H
 
 #ifdef CONFIG_SFI
-#include <acpi/acpi.h>	/* FIXME: inclusion should be removed */
+
+#include <acpi/acpi.h>
+#include <linux/acpi.h>
 
 extern int sfi_acpi_table_parse(char *signature, char *oem_id,
 				char *oem_table_id,
-- 
1.8.4.4


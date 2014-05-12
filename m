Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbaELHqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:46:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:56308 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbaELHqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:46:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1033,1389772800"; 
   d="scan'208";a="510115761"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v3 1/4] ACPICA: Linux headers: Remove ACPI_PREEMPTION_POINT() due to no usages.
Date: Mon, 12 May 2014 15:45:54 +0800
Message-Id: <5fb6fe40cb0a91e454072d567695666dccac3e16.1399880022.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1399880022.git.lv.zheng@intel.com>
References: <cover.1396930406.git.lv.zheng@intel.com> <cover.1399880022.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch deletes deprecated ACPI_PREEMPTION_POINT(), there is no user for
it in Linux kernel now. Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 include/acpi/platform/aclinux.h |   14 --------------
 1 file changed, 14 deletions(-)

diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index 4c2f9e7..3b8b52f 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -228,20 +228,6 @@ static inline acpi_thread_id acpi_os_get_thread_id(void)
 
 #define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_get_thread_id
 
-#ifndef CONFIG_PREEMPT
-
-/*
- * Used within ACPICA to show where it is safe to preempt execution
- * when CONFIG_PREEMPT=n
- */
-#define ACPI_PREEMPTION_POINT() \
-	do { \
-		if (!irqs_disabled()) \
-			cond_resched(); \
-	} while (0)
-
-#endif
-
 /*
  * When lockdep is enabled, the spin_lock_init() macro stringifies it's
  * argument and uses that as a name for the lock in debugging.
-- 
1.7.10


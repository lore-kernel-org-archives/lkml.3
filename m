Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbaDWGyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 02:54:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:26885 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756589AbaDWGys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 02:54:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,910,1389772800"; 
   d="scan'208";a="422363299"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 5/5] ACPICA: Remove deprecated _LINUX definitions for ACPICA.
Date: Wed, 23 Apr 2014 14:54:22 +0800
Message-Id: <8e6c90efc629b463709aef5da4957e916fdc0437.1398232409.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398232408.git.lv.zheng@intel.com>
References: <cover.1396930406.git.lv.zheng@intel.com> <cover.1398232408.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are _LINUX defined so that when Linux kernel is compiled using broken
compilers that having not __linux__ defined can still include
<acpi/platform/aclinux.h> from <acpi/platform/acenv.h>.

This behavior is deprecated as all drivers/acpi/acpica files are compiled
without including <linux/acpi.h>, thus without _LINUX defined.  As there is
no issues encountered when we compile ACPICA code without _LINUX defined,
it is OK to remove _LINUX from <linux/acpi.h> now.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 include/linux/acpi.h |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 7a8f2cd..9c559f7 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -31,10 +31,6 @@
 
 #ifdef	CONFIG_ACPI
 
-#ifndef _LINUX
-#define _LINUX
-#endif
-
 #include <linux/list.h>
 #include <linux/mod_devicetable.h>
 
-- 
1.7.10


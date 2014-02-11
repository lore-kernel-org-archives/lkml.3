Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaBKCwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 21:52:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:4148 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbaBKCvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 21:51:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,822,1384329600"; 
   d="scan'208";a="479388977"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 1/2] ACPICA: acpidump: Add sparse declarators support.
Date: Tue, 11 Feb 2014 10:51:33 +0800
Message-Id: <451efbbddc55b941e64e294c9fcbda5c71e87d0a.1392086457.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1392086457.git.lv.zheng@intel.com>
References: <cover.1392086457.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux kernel build is not affected by this commit.

Linux kernel resident ACPICA headers include some sparse declarators for
kernel static checkers.  This patch adds code to disable them for non
__KERNEL__ defined code so that it is possible for the ACPICA user space
tool's source files to be built with Linux kernel ACPICA header files
included.  Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 include/acpi/platform/aclinux.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index 30c9a7c..f41f59b 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -89,6 +89,16 @@
 #include <ctype.h>
 #include <unistd.h>
 
+/* Disable kernel specific declarators */
+
+#ifndef __init
+#define __init
+#endif
+
+#ifndef __iomem
+#define __iomem
+#endif
+
 /* Host-dependent types and defines for user-space ACPICA */
 
 #define ACPI_FLUSH_CPU_CACHE()
-- 
1.7.10


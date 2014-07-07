Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaGGERc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 00:17:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:39591 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054AbaGGERa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 00:17:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,616,1400050800"; 
   d="scan'208";a="558140191"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 4/7] ACPICA: Linux: Allow ACPICA inclusion for CONFIG_ACPI=n builds.
Date: Mon,  7 Jul 2014 12:17:22 +0800
Message-Id: <be90d00203335f8a16702e7daa7fdf158c562358.1404706299.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1404706298.git.lv.zheng@intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com> <cover.1404706298.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves <acpi/acpi.h> out of CONFIG_ACPI condition so that all
ACPICA prototypes can be seen by the CONFIG_ACPI=n Linux kernel builds.
Note that we can do this because ACPICA has implemented stubs for all
ACPICA prototypes that are currently referenced by the Linux kernel.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 include/linux/acpi.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 358c01b..5320153 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -29,17 +29,17 @@
 #include <linux/ioport.h>	/* for struct resource */
 #include <linux/device.h>
 
-#ifdef	CONFIG_ACPI
-
 #ifndef _LINUX
 #define _LINUX
 #endif
+#include <acpi/acpi.h>
+
+#ifdef	CONFIG_ACPI
 
 #include <linux/list.h>
 #include <linux/mod_devicetable.h>
 #include <linux/dynamic_debug.h>
 
-#include <acpi/acpi.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 #include <acpi/acpi_numa.h>
-- 
1.7.10


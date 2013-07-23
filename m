Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab3GWIKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:10:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:28284 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab3GWIKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:10:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,725,1367996400"; 
   d="scan'208";a="369553636"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Corey Minyard <minyard@acm.org>,
        Zhao Yakui <yakui.zhao@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Subject: [PATCH 10/13] ACPI/IPMI: Cleanup some inclusion codes
Date: Tue, 23 Jul 2013 16:10:22 +0800
Message-Id: <71a378e26c90346665f244f6d505f74f3341394a.1374566394.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1374566394.git.lv.zheng@intel.com>
References: <cover.1370652213.git.lv.zheng@intel.com> <cover.1374566394.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a trivial patch:
1. Deletes several useless header inclusions.
2. Kernel codes should always include <linux/acpi.h> instead of
   <acpi/acpi_bus.h> or <acpi/acpi_drivers.h> where many conditional
   declarations are handled.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Reviewed-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/acpi_ipmi.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/acpi/acpi_ipmi.c b/drivers/acpi/acpi_ipmi.c
index 2d31003..e56b1f8 100644
--- a/drivers/acpi/acpi_ipmi.c
+++ b/drivers/acpi/acpi_ipmi.c
@@ -24,22 +24,9 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 
-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
-#include <linux/types.h>
-#include <linux/delay.h>
-#include <linux/proc_fs.h>
-#include <linux/seq_file.h>
-#include <linux/interrupt.h>
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <linux/io.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include <linux/ipmi.h>
-#include <linux/device.h>
-#include <linux/pnp.h>
 #include <linux/spinlock.h>
 
 MODULE_AUTHOR("Zhao Yakui");
-- 
1.7.10


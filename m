Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab3LFIwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:52:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:51555 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757377Ab3LFIwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:52:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,839,1378882800"; 
   d="scan'208";a="447872616"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v3 1/6] ACPI: Clean up incorrect inclusions of ACPICA headers
Date: Fri,  6 Dec 2013 16:51:46 +0800
Message-Id: <91be0998578a1001db1382012676ee0a69d5cee3.1386317385.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1386316208.git.lv.zheng@intel.com>
References: <cover.1385094640.git.lv.zheng@intel.com> <cover.1386316208.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Header file <acpi/acpi.h> contains environemnt settings and architecture
specific implementation that should be included before any other ACPICA
headers in order to keep a consistent build environment for ACPICA users.
The following internal ACPICA header files should be included from
<acpi/acpi.h> and should not be included by other kernel files:
  <acpi/acpiosxf.h>
  <acpi/acpixf.h>

Clean up incorrect inclusions of these files from non-ACPICA source
files.

[rjw: Subject and changelog]
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/nvs.c           |    1 -
 drivers/hwmon/asus_atk0110.c |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/acpi/nvs.c b/drivers/acpi/nvs.c
index 266bc58..386a9fe 100644
--- a/drivers/acpi/nvs.c
+++ b/drivers/acpi/nvs.c
@@ -13,7 +13,6 @@
 #include <linux/slab.h>
 #include <linux/acpi.h>
 #include <linux/acpi_io.h>
-#include <acpi/acpiosxf.h>
 
 /* ACPI NVS regions, APEI may use it */
 
diff --git a/drivers/hwmon/asus_atk0110.c b/drivers/hwmon/asus_atk0110.c
index b25c643..05fd83e 100644
--- a/drivers/hwmon/asus_atk0110.c
+++ b/drivers/hwmon/asus_atk0110.c
@@ -18,7 +18,6 @@
 #include <linux/err.h>
 
 #include <acpi/acpi.h>
-#include <acpi/acpixf.h>
 #include <acpi/acpi_drivers.h>
 #include <acpi/acpi_bus.h>
 
-- 
1.7.10


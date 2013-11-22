Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab3KVX3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 18:29:13 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:51676 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab3KVX3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 18:29:11 -0500
From: Lv Zheng <zetalog@gmail.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <zetalog@gmail.com>, Lv Zheng <lv.zheng@intel.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 1/4] ACPICA: Linux: Cleanup wrong ACPICA inclusions.
Date: Sat, 23 Nov 2013 07:27:27 +0800
Message-Id: <e57ce3b292120293cafccb055af9754a1713ae6b.1385094641.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1385094640.git.lv.zheng@intel.com>
References: <cover.1385094640.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lv Zheng <lv.zheng@intel.com>

The header file <acpi/acpi.h> is the top level header for other kernel
subsystems to include.  It contains environemnt settings and architecture
specific implementation that should be included before including other
ACPICA headers in order to keep a consistent build environment for ACPICA
users.  All following internal ACPICA header files thus should be included
from <acpi/acpi.h> and not included by other kernel files:
  <acpi/acnames.h>
  <acpi/actypes.h>
  <acpi/acexcep.h>
  <acpi/acexcep.h>
  <acpi/acoutput.h>
  <acpi/acrestyp.h>
  <acpi/acpiosxf.h>
  <acpi/acpixf.h>
  <acpi/acconfig.h>: included by <acpi/acpixf.h>
  <acpi/acconfig.h>
  <acpi/actbl.h>
  <acpi/actbl1.h>: included by <acpi/actbl.h>
  <acpi/actbl2.h>: included by <acpi/actbl.h>
  <acpi/actbl3.h>: included by <acpi/actbl.h>
  <acpi/platform/acenv.h>
  <acpi/platform/aclinux.h>: included by <acpi/platform/acenv.h>
This patch cleans up inclusions of above files from non ACPICA source
files.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
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
index 1d7ff46..dafc63c 100644
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbaG3EXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 00:23:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:60746 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932AbaG3EVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 00:21:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,762,1400050800"; 
   d="scan'208";a="462977228"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 11/17] ACPICA: ACPI 5.1: New notify value for System Affinity Update.
Date: Wed, 30 Jul 2014 12:21:31 +0800
Message-Id: <a78669993ef142688be438d414243bfe27695a8e.1406689494.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1406689493.git.lv.zheng@intel.com>
References: <cover.1406689493.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

New value for the Notify() operator.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/utdecode.c |    5 +++--
 include/acpi/actypes.h         |    3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpica/utdecode.c b/drivers/acpi/acpica/utdecode.c
index 98f5418..40e923e 100644
--- a/drivers/acpi/acpica/utdecode.c
+++ b/drivers/acpi/acpica/utdecode.c
@@ -448,7 +448,8 @@ static const char *acpi_gbl_generic_notify[ACPI_NOTIFY_MAX + 1] = {
 	/* 09 */ "Device PLD Check",
 	/* 0A */ "Reserved",
 	/* 0B */ "System Locality Update",
-	/* 0C */ "Shutdown Request"
+	/* 0C */ "Shutdown Request",
+	/* 0D */ "System Resource Affinity Update"
 };
 
 static const char *acpi_gbl_device_notify[4] = {
@@ -475,7 +476,7 @@ static const char *acpi_gbl_thermal_notify[4] = {
 const char *acpi_ut_get_notify_name(u32 notify_value, acpi_object_type type)
 {
 
-	/* 00 - 0C are common to all object types */
+	/* 00 - 0D are common to all object types */
 
 	if (notify_value <= ACPI_NOTIFY_MAX) {
 		return (acpi_gbl_generic_notify[notify_value]);
diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index 4d9b29c..ac03ec8 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -612,8 +612,9 @@ typedef u64 acpi_integer;
 #define ACPI_NOTIFY_RESERVED            (u8) 0x0A
 #define ACPI_NOTIFY_LOCALITY_UPDATE     (u8) 0x0B
 #define ACPI_NOTIFY_SHUTDOWN_REQUEST    (u8) 0x0C
+#define ACPI_NOTIFY_AFFINITY_UPDATE     (u8) 0x0D
 
-#define ACPI_NOTIFY_MAX                 0x0C
+#define ACPI_NOTIFY_MAX                 0x0D
 
 /*
  * Types associated with ACPI names and objects. The first group of
-- 
1.7.10


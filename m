Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaELHuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:50:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:45626 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbaELHuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:50:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1033,1389772800"; 
   d="scan'208";a="510117750"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Enrico Etxe Arte <goitizena.generoa@gmail.com>
Subject: [PATCH v3 2/2] ACPI: Fix the issue that the DSDT local copy is conflict with the customized DSDT.
Date: Mon, 12 May 2014 15:50:16 +0800
Message-Id: <e10c2a17e698dd9a2594320388b8aa4da6c28418.1399880919.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1396925060.git.lv.zheng@intel.com>
References: <cover.1396925060.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following issue:
If DSDT is customized, no local DSDT copy is needed.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=69711
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Enrico Etxe Arte <goitizena.generoa@gmail.com>
Cc: <stable@vger.kernel.org> # 2.6.35.x: aa2110cb: ACPI: add boot option acpi=copy_dsdt to fix corrupt DSDT
---
 drivers/acpi/bus.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 610261a..cfd2318 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -52,6 +52,12 @@ struct proc_dir_entry *acpi_root_dir;
 EXPORT_SYMBOL(acpi_root_dir);
 
 #ifdef CONFIG_X86
+#ifdef CONFIG_ACPI_CUSTOM_DSDT
+static inline int set_copy_dsdt(const struct dmi_system_id *id)
+{
+	return 0;
+}
+#else
 static int set_copy_dsdt(const struct dmi_system_id *id)
 {
 	printk(KERN_NOTICE "%s detected - "
@@ -59,6 +65,7 @@ static int set_copy_dsdt(const struct dmi_system_id *id)
 	acpi_gbl_copy_dsdt_locally = 1;
 	return 0;
 }
+#endif
 
 static struct dmi_system_id dsdt_dmi_table[] __initdata = {
 	/*
-- 
1.7.10


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab3GWINI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:13:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:37853 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755775Ab3GWIKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:10:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,725,1367996400"; 
   d="scan'208";a="350032636"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Corey Minyard <minyard@acm.org>,
        Zhao Yakui <yakui.zhao@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Subject: [PATCH 09/13] ACPI/IPMI: Cleanup some initialization codes
Date: Tue, 23 Jul 2013 16:10:13 +0800
Message-Id: <9a0e5abf2ba5b9965867569e41574fda49826f16.1374566394.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1374566394.git.lv.zheng@intel.com>
References: <cover.1370652213.git.lv.zheng@intel.com> <cover.1374566394.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a trivial patch.
1. Changes dynamic mutex initialization to static initialization.
2. Removes one acpi_ipmi_init() variable initialization as it is not
   needed.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Reviewed-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/acpi_ipmi.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/acpi_ipmi.c b/drivers/acpi/acpi_ipmi.c
index 7f93ffd..2d31003 100644
--- a/drivers/acpi/acpi_ipmi.c
+++ b/drivers/acpi/acpi_ipmi.c
@@ -128,6 +128,7 @@ static struct ipmi_driver_data driver_data = {
 	.ipmi_hndlrs = {
 		.ipmi_recv_hndl = ipmi_msg_handler,
 	},
+	.ipmi_lock = __MUTEX_INITIALIZER(driver_data.ipmi_lock)
 };
 
 static struct acpi_ipmi_device *
@@ -583,12 +584,10 @@ out_msg:
 
 static int __init acpi_ipmi_init(void)
 {
-	int result = 0;
+	int result;
 
 	if (acpi_disabled)
-		return result;
-
-	mutex_init(&driver_data.ipmi_lock);
+		return 0;
 
 	result = acpi_register_region(ACPI_ADR_SPACE_IPMI,
 				      &acpi_ipmi_space_handler,
-- 
1.7.10


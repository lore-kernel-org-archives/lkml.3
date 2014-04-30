Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbaD3CDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:03:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:40581 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbaD3CDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:03:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,955,1389772800"; 
   d="scan'208";a="532134443"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 02/27] ACPICA: Utilities: Deploy ACPI_DEBUGGER_EXEC for ACPI_DEBUGGER enabled code in utglobal.c.
Date: Wed, 30 Apr 2014 10:03:39 +0800
Message-Id: <53dbe352c16de24ea99d00af21eb01750af90074.1398817612.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398817612.git.lv.zheng@intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch deploys ACPI_DEBUGGER_EXEC usage to utglobal.c to reduce "ifdef"
of ACPI_DEBUGGER.  No functional changes.  Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
---
 drivers/acpi/acpica/utglobal.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/acpi/acpica/utglobal.c b/drivers/acpi/acpica/utglobal.c
index f3abeae..825b064 100644
--- a/drivers/acpi/acpica/utglobal.c
+++ b/drivers/acpi/acpica/utglobal.c
@@ -377,9 +377,7 @@ acpi_status acpi_ut_init_globals(void)
 	acpi_gbl_disable_mem_tracking = FALSE;
 #endif
 
-#ifdef ACPI_DEBUGGER
-	acpi_gbl_db_terminate_threads = FALSE;
-#endif
+	ACPI_DEBUGGER_EXEC(acpi_gbl_db_terminate_threads = FALSE);
 
 	return_ACPI_STATUS(AE_OK);
 }
-- 
1.7.10


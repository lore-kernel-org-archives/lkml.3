Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab3GWIMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:12:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:28284 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab3GWIKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:10:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,725,1367996400"; 
   d="scan'208";a="271952334"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Corey Minyard <minyard@acm.org>,
        Zhao Yakui <yakui.zhao@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Subject: [PATCH 11/13] ACPI/IPMI: Cleanup some Kconfig codes
Date: Tue, 23 Jul 2013 16:10:30 +0800
Message-Id: <7f0aa3cc70233fdb523fbb75dadadc03358e836f.1374566394.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1374566394.git.lv.zheng@intel.com>
References: <cover.1370652213.git.lv.zheng@intel.com> <cover.1374566394.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a trivial patch:
1. Deletes duplicate Kconfig dependency as there is "if IPMI_HANDLER"
   around "IPMI_SI".

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Reviewed-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 3278a21..d129869 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -181,9 +181,10 @@ config ACPI_PROCESSOR
 
 	  To compile this driver as a module, choose M here:
 	  the module will be called processor.
+
 config ACPI_IPMI
 	tristate "IPMI"
-	depends on IPMI_SI && IPMI_HANDLER
+	depends on IPMI_SI
 	default n
 	help
 	  This driver enables the ACPI to access the BMC controller. And it
-- 
1.7.10


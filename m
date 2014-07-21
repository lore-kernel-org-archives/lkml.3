Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbaGUGGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:06:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:30036 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbaGUGGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:06:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="459362924"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH v3 09/14] ACPI/EC: Add CPU ID to debugging messages.
Date: Mon, 21 Jul 2014 14:06:03 +0800
Message-Id: <0df1aae6d110e053dfe2df7377e5c938d4bbf076.1405922585.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405922585.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405922585.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds CPU ID to the context entries' debugging output. no
functional changes.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/ec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index a729f31..065aabc 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -286,7 +286,8 @@ static bool advance_transaction(struct acpi_ec *ec)
 	u8 status;
 	bool wakeup = false;
 
-	pr_debug("===== %s =====\n", in_interrupt() ? "IRQ" : "TASK");
+	pr_debug("===== %s (%d) =====\n",
+		 in_interrupt() ? "IRQ" : "TASK", smp_processor_id());
 	status = acpi_ec_read_status(ec);
 	t = ec->curr;
 	if (!t)
-- 
1.7.10


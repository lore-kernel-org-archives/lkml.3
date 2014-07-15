Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846AbaGODI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:08:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:42325 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757808AbaGODIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:08:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,662,1400050800"; 
   d="scan'208";a="456988830"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 9/9] ACPI: Update interrupt handler to honor new ACPI_REENABLE_GPE bit.
Date: Tue, 15 Jul 2014 11:08:11 +0800
Message-Id: <c5b1da8473759b4fab769c6260a259926d68b22b.1405306438.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405306438.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405306438.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of ACPICA SCI will contain ACPI_REENABLE_GPE. This patch
cleans up the OSL code to reflect this change.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/osl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index bad25b0..b524186 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -788,7 +788,7 @@ static irqreturn_t acpi_irq(int irq, void *dev_id)
 
 	handled = (*acpi_irq_handler) (acpi_irq_context);
 
-	if (handled) {
+	if (handled & ACPI_INTERRUPT_HANDLED) {
 		acpi_irq_handled++;
 		return IRQ_HANDLED;
 	} else {
-- 
1.7.10


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab3DWS2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:28:16 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:40677 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508Ab3DWS2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:28:14 -0400
From: Linn Crosetto <linn@hp.com>
To: joro@8bytes.org, mingo@kernel.org, ddutile@redhat.com,
        suresh.b.siddha@intel.com
Cc: linux-kernel@vger.kernel.org, Linn Crosetto <linn@hp.com>
Subject: [PATCH] iommu: dmar -- remove warning for HPET scope type
Date: Tue, 23 Apr 2013 12:26:45 -0600
Message-Id: <1366741605-71293-1-git-send-email-linn@hp.com>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI_DMAR_SCOPE_TYPE_HPET is parsed by ir_parse_ioapic_hpet_scope() and
should not be flagged as an unsupported type.

Signed-off-by: Linn Crosetto <linn@hp.com>
---
 drivers/iommu/dmar.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index e5cdaf8..b8008f6 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -129,7 +129,8 @@ int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
 		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT ||
 		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE)
 			(*cnt)++;
-		else if (scope->entry_type != ACPI_DMAR_SCOPE_TYPE_IOAPIC) {
+		else if (scope->entry_type != ACPI_DMAR_SCOPE_TYPE_IOAPIC &&
+			scope->entry_type != ACPI_DMAR_SCOPE_TYPE_HPET) {
 			pr_warn("Unsupported device scope\n");
 		}
 		start += scope->length;
-- 
1.7.11.3


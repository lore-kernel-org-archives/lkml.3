Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab3DXJbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:31:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39140 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab3DXJbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:31:48 -0400
Date: Wed, 24 Apr 2013 02:31:22 -0700
From: tip-bot for Linn Crosetto <tipbot@zytor.com>
Message-ID: <tip-13f72756da86f155898e2c2022f7b3a106c3742e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org, linn@hp.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linn@hp.com, tglx@linutronix.de
In-Reply-To: <1366741605-71293-1-git-send-email-linn@hp.com>
References: <1366741605-71293-1-git-send-email-linn@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/iommu/dmar: Remove warning for HPET scope type
Git-Commit-ID: 13f72756da86f155898e2c2022f7b3a106c3742e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13f72756da86f155898e2c2022f7b3a106c3742e
Gitweb:     http://git.kernel.org/tip/13f72756da86f155898e2c2022f7b3a106c3742e
Author:     Linn Crosetto <linn@hp.com>
AuthorDate: Tue, 23 Apr 2013 12:26:45 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Apr 2013 08:45:47 +0200

x86/iommu/dmar: Remove warning for HPET scope type

ACPI_DMAR_SCOPE_TYPE_HPET is parsed by
ir_parse_ioapic_hpet_scope() and should not be flagged as an
unsupported type.

Signed-off-by: Linn Crosetto <linn@hp.com>
Cc: joro@8bytes.org
Cc: ddutile@redhat.com
Cc: suresh.b.siddha@intel.com
Link: http://lkml.kernel.org/r/1366741605-71293-1-git-send-email-linn@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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

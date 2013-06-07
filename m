Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab3FGXIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:08:14 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:61836 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679Ab3FGXDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:52 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 19/31] mips/kvm: Add host definitions for MIPS VZ based host.
Date: Fri,  7 Jun 2013 16:03:23 -0700
Message-Id: <1370646215-6543-20-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/include/asm/kvm_mips_vz.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 arch/mips/include/asm/kvm_mips_vz.h

diff --git a/arch/mips/include/asm/kvm_mips_vz.h b/arch/mips/include/asm/kvm_mips_vz.h
new file mode 100644
index 0000000..dfc6951
--- /dev/null
+++ b/arch/mips/include/asm/kvm_mips_vz.h
@@ -0,0 +1,29 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2013 Cavium, Inc.
+ */
+#ifndef _ASM_KVM_MIPS_VZ_H
+#define _ASM_KVM_MIPS_VZ_H
+
+struct kvm;
+
+struct kvm_mips_vz {
+	struct mutex guest_mm_lock;
+	pgd_t *pgd;			/* Translations for this host. */
+	spinlock_t irq_chip_lock;
+	struct page *irq_chip;
+	unsigned int asid[NR_CPUS];	/* Per CPU ASIDs for pgd. */
+};
+
+bool mipsvz_page_fault(struct pt_regs *regs, unsigned long write,
+		       unsigned long address);
+
+bool mipsvz_cp_unusable(struct pt_regs *regs);
+int mipsvz_arch_init(void *opaque);
+int mipsvz_arch_hardware_enable(void *garbage);
+int mipsvz_init_vm(struct kvm *kvm, unsigned long type);
+
+#endif /* _ASM_KVM_MIPS_VZ_H */
-- 
1.7.11.7


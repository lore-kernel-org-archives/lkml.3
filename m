Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab3EVSoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:44:11 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:47130 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab3EVSoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:44:08 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH v5 2/6] mips/kvm: Fix ABI for use of 64-bit registers.
Date: Wed, 22 May 2013 11:43:52 -0700
Message-Id: <1369248236-27237-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1369248236-27237-1-git-send-email-ddaney.cavm@gmail.com>
References: <1369248236-27237-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

All registers are 64-bits wide, 32-bit guests use the least
significant portion of the register storage fields.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/include/asm/kvm.h | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/mips/include/asm/kvm.h b/arch/mips/include/asm/kvm.h
index 0e8f565..86812fb 100644
--- a/arch/mips/include/asm/kvm.h
+++ b/arch/mips/include/asm/kvm.h
@@ -18,12 +18,18 @@
 #define N_MIPS_COPROC_REGS      32
 #define N_MIPS_COPROC_SEL   	8
 
-/* for KVM_GET_REGS and KVM_SET_REGS */
+/*
+ * for KVM_GET_REGS and KVM_SET_REGS
+ *
+ * If Config[AT] is zero (32-bit CPU), the register contents are
+ * stored in the lower 32-bits of the struct kvm_regs fields and sign
+ * extended to 64-bits.
+ */
 struct kvm_regs {
-	__u32 gprs[32];
-	__u32 hi;
-	__u32 lo;
-	__u32 pc;
+	__u64 gprs[32];
+	__u64 hi;
+	__u64 lo;
+	__u64 pc;
 
 	__u32 cp0reg[N_MIPS_COPROC_REGS][N_MIPS_COPROC_SEL];
 };
-- 
1.7.11.7


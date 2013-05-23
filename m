Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945Ab3EWQv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:51:29 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53721 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759328Ab3EWQtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:49:18 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH v6 1/6] mips/kvm: Fix ABI for use of FPU.
Date: Thu, 23 May 2013 09:49:05 -0700
Message-Id: <1369327750-28580-2-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1369327750-28580-1-git-send-email-ddaney.cavm@gmail.com>
References: <1369327750-28580-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Define a non-empty struct kvm_fpu.

Signed-off-by: David Daney <david.daney@cavium.com>
Acked-by: Sanjay Lal <sanjayl@kymasys.com>
---
 arch/mips/include/uapi/asm/kvm.h | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/mips/include/uapi/asm/kvm.h b/arch/mips/include/uapi/asm/kvm.h
index 85789ea..0e8f565 100644
--- a/arch/mips/include/uapi/asm/kvm.h
+++ b/arch/mips/include/uapi/asm/kvm.h
@@ -1,11 +1,12 @@
 /*
-* This file is subject to the terms and conditions of the GNU General Public
-* License.  See the file "COPYING" in the main directory of this archive
-* for more details.
-*
-* Copyright (C) 2012  MIPS Technologies, Inc.  All rights reserved.
-* Authors: Sanjay Lal <sanjayl@kymasys.com>
-*/
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2012  MIPS Technologies, Inc.  All rights reserved.
+ * Copyright (C) 2013 Cavium, Inc.
+ * Authors: Sanjay Lal <sanjayl@kymasys.com>
+ */
 
 #ifndef __LINUX_KVM_MIPS_H
 #define __LINUX_KVM_MIPS_H
@@ -31,8 +32,20 @@ struct kvm_regs {
 struct kvm_sregs {
 };
 
-/* for KVM_GET_FPU and KVM_SET_FPU */
+/*
+ * for KVM_GET_FPU and KVM_SET_FPU
+ *
+ * If Status[FR] is zero (32-bit FPU), the upper 32-bits of the FPRs
+ * are zero filled.
+ */
 struct kvm_fpu {
+	__u64 fpr[32];
+	__u32 fir;
+	__u32 fccr;
+	__u32 fexr;
+	__u32 fenr;
+	__u32 fcsr;
+	__u32 pad;
 };
 
 struct kvm_debug_exit_arch {
-- 
1.7.11.7


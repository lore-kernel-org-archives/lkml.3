Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbaIQMys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:54:48 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:42952 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252AbaIQMy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:54:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah0FAPqDGVSERCAB/2dsb2JhbABggw2BKtByAYEVFgEBeIQEAQV5EB00SQ4ZiD63eoZFj0sHhEsFizmnF4NhaYJKAQEB
X-IPAS-Result: Ah0FAPqDGVSERCAB/2dsb2JhbABggw2BKtByAYEVFgEBeIQEAQV5EB00SQ4ZiD63eoZFj0sHhEsFizmnF4NhaYJKAQEB
X-IronPort-AV: E=Sophos;i="5.04,540,1406581200"; 
   d="scan'208";a="122640333"
From: Nadav Amit <namit@cs.technion.ac.il>
To: bp@alien8.de
Cc: mingo@kernel.org, nadav.amit@gmail.com, pbonzini@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, Nadav Amit <namit@cs.technion.ac.il>
Subject: [RESEND PATCH 1/3] x86: Adding structs to reflect cpuid fields
Date: Wed, 17 Sep 2014 15:54:12 +0300
Message-Id: <1410958454-7501-2-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410958454-7501-1-git-send-email-namit@cs.technion.ac.il>
References: <20140917124501.GC5358@nazgul.tnic>
 <1410958454-7501-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding structs that reflect various cpuid fields in x86 architecture. Structs
were added only for functions that are not pure bitmaps.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/include/asm/cpuid_def.h | 163 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 163 insertions(+)
 create mode 100644 arch/x86/include/asm/cpuid_def.h

diff --git a/arch/x86/include/asm/cpuid_def.h b/arch/x86/include/asm/cpuid_def.h
new file mode 100644
index 0000000..0cf43ba
--- /dev/null
+++ b/arch/x86/include/asm/cpuid_def.h
@@ -0,0 +1,163 @@
+#ifndef ARCH_X86_KVM_CPUID_DEF_H
+#define ARCH_X86_KVM_CPUID_DEF_H
+
+union cpuid1_eax {
+	struct {
+		unsigned int stepping_id:4;
+		unsigned int model:4;
+		unsigned int family_id:4;
+		unsigned int processor_type:2;
+		unsigned int reserved:2;
+		unsigned int extended_model_id:4;
+		unsigned int extended_family_id:8;
+		unsigned int reserved2:4;
+	} split;
+	unsigned int full;
+};
+
+union cpuid1_ebx {
+	struct {
+		unsigned int brand_index:8;
+		unsigned int clflush_size:8;
+		unsigned int max_logical_proc:8;
+		unsigned int initial_apicid:8;
+	} split;
+	unsigned int full;
+};
+
+union cpuid4_eax {
+	struct {
+		unsigned int cache_type:5;
+		unsigned int cache_level:3;
+		unsigned int self_init_cache_level:1;
+		unsigned int fully_associative:1;
+		unsigned int reserved:4;
+		unsigned int max_logical_proc:12;
+		unsigned int max_package_proc:6;
+	} split;
+	unsigned int full;
+};
+
+union cpuid4_ebx {
+	struct {
+		unsigned int coherency_line_size:12;
+		unsigned int physical_line_partitions:10;
+		unsigned int ways:10;
+	} split;
+	unsigned int full;
+};
+
+union cpuid5_eax {
+	struct {
+		unsigned int min_monitor_line_size:16;
+		unsigned int reserved:16;
+	} split;
+	unsigned int full;
+};
+
+union cpuid5_ebx {
+	struct {
+		unsigned int max_monitor_line_size:16;
+		unsigned int reserved:16;
+	} split;
+	unsigned int full;
+};
+
+union cpuid5_ecx {
+	struct {
+		unsigned int monitor_mwait_ext:1;
+		unsigned int interrupt_as_break:1;
+	} split;
+	unsigned int full;
+};
+
+union cpuid5_edx {
+	struct {
+		unsigned int c0_sub_states:4;
+		unsigned int c1_sub_states:4;
+		unsigned int c2_sub_states:4;
+		unsigned int c3_sub_states:4;
+		unsigned int c4_sub_states:4;
+		unsigned int c5_sub_states:4;
+		unsigned int c6_sub_states:4;
+		unsigned int c7_sub_states:4;
+	} split;
+	unsigned int full;
+};
+
+union cpuid11_eax {
+	struct {
+		unsigned int x2apic_shift:5;
+		unsigned int reserved:27;
+	} split;
+	unsigned int full;
+};
+
+union cpuid11_ebx {
+	struct {
+		unsigned int logical_proc:16;
+		unsigned int reserved:16;
+	} split;
+	unsigned int full;
+};
+
+union cpuid11_ecx {
+	struct {
+		unsigned int level_number:8;
+		unsigned int level_type:8;
+		unsigned int reserved:16;
+	} split;
+	unsigned int full;
+};
+
+union cpuid8_5_eax_ebx {
+	struct {
+		unsigned int itlb_entries:8;
+		unsigned int itlb_assoc:8;
+		unsigned int dtlb_entries:8;
+		unsigned int dtlb_assoc:8;
+	} split;
+	unsigned int full;
+};
+
+union cpuid8_5_ecx_edx {
+	struct {
+		unsigned int line_size:8;
+		unsigned int lines_per_tag:8;
+		unsigned int associativity:8;
+		unsigned int cache_size:8;
+	} split;
+	unsigned int full;
+};
+
+union cpuid8_6_ebx {
+	struct {
+		unsigned int itlb_entries:12;
+		unsigned int itlb_assoc:4;
+		unsigned int dtlb_entries:12;
+		unsigned int dtlb_assoc:4;
+	} split;
+	unsigned int full;
+};
+
+union cpuid8_6_ecx {
+	struct {
+		unsigned int cache_line_size:8;
+		unsigned int lines_per_tag:4;
+		unsigned int l2_associativity:4;
+		unsigned int cache_size:16;
+	} split;
+	unsigned int full;
+};
+
+union cpuid_8_8_eax {
+	struct {
+		unsigned int phys_as:8;
+		unsigned int virt_as:8;
+		unsigned int guest_phys_as:8;
+		unsigned int reserved:8;
+	} split;
+	unsigned int full;
+};
+
+#endif
-- 
1.9.1


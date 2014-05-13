Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965078AbaEMPAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:00:37 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:43011 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964896AbaEMPAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:00:32 -0400
From: Michael Mueller <mimu@linux.vnet.ibm.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexander Graf <agraf@suse.de>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Andreas Faerber <afaerber@suse.de>,
        "Jason J. Herne" <jjherne@linux.vnet.ibm.com>, mimu@linux.vnet.ibm.com
Subject: [PATCH v1 RFC 05/10] s390: update linux-headers for kvm VM device attributes
Date: Tue, 13 May 2014 17:00:17 +0200
Message-Id: <1399993222-16339-6-git-send-email-mimu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1399993222-16339-1-git-send-email-mimu@linux.vnet.ibm.com>
References: <1399993222-16339-1-git-send-email-mimu@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051315-5024-0000-0000-000009D046BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael Mueller <mimu@linux.vnet.ibm.com>
---
 linux-headers/asm-s390/kvm.h | 26 ++++++++++++++++++++++++++
 linux-headers/linux/kvm.h    |  1 +
 2 files changed, 27 insertions(+)

diff --git a/linux-headers/asm-s390/kvm.h b/linux-headers/asm-s390/kvm.h
index c003c6a..2fba454 100644
--- a/linux-headers/asm-s390/kvm.h
+++ b/linux-headers/asm-s390/kvm.h
@@ -54,6 +54,32 @@ struct kvm_s390_io_adapter_req {
 	__u64 addr;
 };
 
+/* kvm attr_group  on vm fd */
+#define KVM_S390_VM_CPU_MODEL		1
+
+/* kvm attributes for mem_ctrl */
+#define KVM_S390_VM_MEM_CLR_CMMA	1
+
+/* kvm S390 processor related attributes */
+#define KVM_S390_VM_CPU_PROCESSOR	0
+struct kvm_s390_vm_cpu_processor {
+	__u64 cpuid;
+	__u16 ibc;
+	__u8  pad[6];
+	__u64 fac_list[256];
+};
+
+/* kvm S390 machine related attributes */
+#define KVM_S390_VM_CPU_MACHINE		1
+struct kvm_s390_vm_cpu_machine {
+	__u64 cpuid;
+	__u32 ibc_range;
+	__u64 fac_mask[256];
+	__u8  pad[4];
+	__u64 hard_fac_list[256];
+	__u64 soft_fac_list[256];
+};
+
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
 	/* general purpose regs for s390 */
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index b278ab3..770ce38 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -743,6 +743,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_IOAPIC_POLARITY_IGNORED 97
 #define KVM_CAP_ENABLE_CAP_VM 98
 #define KVM_CAP_S390_IRQCHIP 99
+#define KVM_CAP_VM_ATTRIBUTES 101
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
1.8.3.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbaKJGlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:41:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:54478 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaKJGgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:36:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,351,1413270000"; 
   d="scan'208";a="629364121"
From: Feng Wu <feng.wu@intel.com>
To: gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [PATCH 03/13] KVM: Add KVM_CAP_PI to detect VT-d Posted-Interrtups
Date: Mon, 10 Nov 2014 14:26:42 +0800
Message-Id: <1415600812-27773-4-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1415600812-27773-1-git-send-email-feng.wu@intel.com>
References: <1415600812-27773-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds KVM_CAP_PI to detect VT-d Posted-Interrtups
feature for QEMU.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 arch/x86/kvm/x86.c       |    4 ++++
 include/uapi/linux/kvm.h |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0033df3..b447a98 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -63,6 +63,7 @@
 #include <asm/xcr.h>
 #include <asm/pvclock.h>
 #include <asm/div64.h>
+#include <asm/irq_remapping.h>
 
 #define MAX_IO_MSRS 256
 #define KVM_MAX_MCE_BANKS 32
@@ -2775,6 +2776,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_TSC_DEADLINE_TIMER:
 		r = boot_cpu_has(X86_FEATURE_TSC_DEADLINE_TIMER);
 		break;
+	case KVM_CAP_PI:
+		r = irq_post_enabled;
+		break;
 	default:
 		r = 0;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6076882..7593c52 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -761,6 +761,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_PPC_FIXUP_HCALL 103
 #define KVM_CAP_PPC_ENABLE_HCALL 104
 #define KVM_CAP_CHECK_EXTENSION_VM 105
+#define KVM_CAP_PI 106
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
1.7.1


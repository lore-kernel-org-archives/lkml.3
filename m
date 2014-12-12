Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934855AbaLLPZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:25:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:36405 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030229AbaLLPZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:25:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,564,1413270000"; 
   d="scan'208";a="622807288"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: eric.auger@linaro.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        Feng Wu <feng.wu@intel.com>
Subject: [v3 11/26] KVM: Add some helper functions for Posted-Interrupts
Date: Fri, 12 Dec 2014 23:14:45 +0800
Message-Id: <1418397300-10870-12-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds some helper functions to manipulate the
Posted-Interrupts Descriptor.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 arch/x86/kvm/vmx.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index abdb84f..0b1383e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -408,6 +408,8 @@ struct nested_vmx {
 };
 
 #define POSTED_INTR_ON  0
+#define POSTED_INTR_SN  1
+
 /* Posted-Interrupt Descriptor */
 struct pi_desc {
 	u32 pir[8];     /* Posted interrupt requested */
@@ -443,6 +445,30 @@ static int pi_test_and_set_pir(int vector, struct pi_desc *pi_desc)
 	return test_and_set_bit(vector, (unsigned long *)pi_desc->pir);
 }
 
+static void pi_clear_sn(struct pi_desc *pi_desc)
+{
+	return clear_bit(POSTED_INTR_SN,
+			(unsigned long *)&pi_desc->control);
+}
+
+static void pi_set_sn(struct pi_desc *pi_desc)
+{
+	return set_bit(POSTED_INTR_SN,
+			(unsigned long *)&pi_desc->control);
+}
+
+static int pi_test_on(struct pi_desc *pi_desc)
+{
+	return test_bit(POSTED_INTR_ON,
+			(unsigned long *)&pi_desc->control);
+}
+
+static int pi_test_sn(struct pi_desc *pi_desc)
+{
+	return test_bit(POSTED_INTR_SN,
+			(unsigned long *)&pi_desc->control);
+}
+
 struct vcpu_vmx {
 	struct kvm_vcpu       vcpu;
 	unsigned long         host_rsp;
-- 
1.9.1


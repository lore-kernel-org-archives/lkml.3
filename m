Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaLCHuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:50:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:60624 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbaLCHuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:50:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,506,1413270000"; 
   d="scan'208";a="631852325"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [v2 11/25] KVM: Add some helper functions for Posted-Interrupts
Date: Wed,  3 Dec 2014 15:39:40 +0800
Message-Id: <1417592394-24343-12-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
References: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds some helper functions to manipulate the
Posted-Interrupts Descriptor.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 arch/x86/kvm/vmx.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

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
1.7.1


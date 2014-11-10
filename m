Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaKJGhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:37:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:13024 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbaKJGhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:37:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,351,1413270000"; 
   d="scan'208";a="629364128"
From: Feng Wu <feng.wu@intel.com>
To: gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [PATCH 06/13] KVM: Add some helper functions for Posted-Interrupts
Date: Mon, 10 Nov 2014 14:26:45 +0800
Message-Id: <1415600812-27773-7-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1415600812-27773-1-git-send-email-feng.wu@intel.com>
References: <1415600812-27773-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds three helper functions to manipulate the Posted-
Interrtups Decriptor.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 arch/x86/kvm/vmx.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ae91b72..f41111f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -435,6 +435,24 @@ static void pi_clear_sn(struct pi_desc *pi_desc)
 			(unsigned long *)&pi_desc->control);
 }
 
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
 static bool pi_test_and_set_on(struct pi_desc *pi_desc)
 {
 	return test_and_set_bit(POSTED_INTR_ON,
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030445AbaLLPZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:25:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:36405 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030356AbaLLPZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:25:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,564,1413270000"; 
   d="scan'208";a="622807253"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: eric.auger@linaro.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        Feng Wu <feng.wu@intel.com>
Subject: [v3 10/26] KVM: change struct pi_desc for VT-d Posted-Interrupts
Date: Fri, 12 Dec 2014 23:14:44 +0800
Message-Id: <1418397300-10870-11-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change struct pi_desc for VT-d Posted-Interrupts.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 arch/x86/kvm/vmx.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 3e556c6..abdb84f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -411,8 +411,19 @@ struct nested_vmx {
 /* Posted-Interrupt Descriptor */
 struct pi_desc {
 	u32 pir[8];     /* Posted interrupt requested */
-	u32 control;	/* bit 0 of control is outstanding notification bit */
-	u32 rsvd[7];
+	union {
+		struct {
+			u64	on	: 1,
+				sn	: 1,
+				rsvd_1	: 13,
+				ndm	: 1,
+				nv	: 8,
+				rsvd_2	: 8,
+				ndst	: 32;
+		};
+		u64 control;
+	};
+	u32 rsvd[6];
 } __aligned(64);
 
 static bool pi_test_and_set_on(struct pi_desc *pi_desc)
-- 
1.9.1


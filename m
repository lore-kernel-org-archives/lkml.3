Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaLCHuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:50:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:60624 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbaLCHuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:50:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,506,1413270000"; 
   d="scan'208";a="631852311"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [v2 10/25] KVM: change struct pi_desc for VT-d Posted-Interrupts
Date: Wed,  3 Dec 2014 15:39:39 +0800
Message-Id: <1417592394-24343-11-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
References: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change struct pi_desc for VT-d Posted-Interrupts.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 arch/x86/kvm/vmx.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

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
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaLCHtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:49:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:60624 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbaLCHts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:49:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,506,1413270000"; 
   d="scan'208";a="631852218"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [v2 03/25] iommu, x86: Define new irte structure for VT-d Posted-Interrupts
Date: Wed,  3 Dec 2014 15:39:32 +0800
Message-Id: <1417592394-24343-4-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
References: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new irte_pi structure for VT-d Posted-Interrupts.

Signed-off-by: Feng Wu <feng.wu@intel.com>
Reviewed-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 include/linux/dmar.h |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 8473756..c7f9cda 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -212,6 +212,38 @@ struct irte {
 	};
 };
 
+struct irte_pi {
+	union {
+		struct {
+			__u64   present		: 1,
+				fpd		: 1,
+				__reserved_1	: 6,
+				avail		: 4,
+				__reserved_2	: 2,
+				urg		: 1,
+				pst		: 1,
+				vector		: 8,
+				__reserved_3	: 14,
+				pda_l		: 26;
+		};
+		__u64 low;
+	};
+
+	union {
+		struct {
+			__u64	sid		: 16,
+				sq		: 2,
+				svt		: 2,
+				__reserved_4	: 12,
+				pda_h		: 32;
+		};
+		__u64 high;
+	};
+};
+
+#define PDA_LOW_BIT    26
+#define PDA_HIGH_BIT   32
+
 enum {
 	IRQ_REMAP_XAPIC_MODE,
 	IRQ_REMAP_X2APIC_MODE,
-- 
1.7.1


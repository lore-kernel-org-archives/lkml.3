Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaLCHuC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:50:02 -0500
Received: from mga11.intel.com ([192.55.52.93]:60624 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbaLCHt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:49:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,506,1413270000"; 
   d="scan'208";a="631852256"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [v2 07/25] iommu, x86: Add cap_pi_support() to detect VT-d PI capability
Date: Wed,  3 Dec 2014 15:39:36 +0800
Message-Id: <1417592394-24343-8-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
References: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add helper function to detect VT-d Posted-Interrupts capability.

Signed-off-by: Feng Wu <feng.wu@intel.com>
Reviewed-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 include/linux/intel-iommu.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index ecaf3a9..8174ae8 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -87,6 +87,7 @@ static inline void dmar_writeq(void __iomem *addr, u64 val)
 /*
  * Decoding Capability Register
  */
+#define cap_pi_support(c)	(((c) >> 59) & 1)
 #define cap_read_drain(c)	(((c) >> 55) & 1)
 #define cap_write_drain(c)	(((c) >> 54) & 1)
 #define cap_max_amask_val(c)	(((c) >> 48) & 0x3f)
-- 
1.7.1


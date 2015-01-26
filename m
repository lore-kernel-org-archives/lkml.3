Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbbAZDfG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 22:35:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:8233 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbbAZDfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 22:35:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,466,1418112000"; 
   d="scan'208";a="667418788"
From: xiaomin1 <xiaoming.wang@intel.com>
To: konrad.wilk@oracle.com, akpm@linux-foundation.org, linux@horizon.com,
        lauraa@codeaurora.org, heiko.carstens@de.ibm.com,
        d.kasatkin@samsung.com, takahiro.akashi@linaro.org,
        chris@chris-wilson.co.uk, u.kleine-koenig@pengutronix.de,
        linux-kernel@vger.kernel.org
Cc: xiaomin1 <xiaoming.wang@intel.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Zhang Dongxing <dongxing.zhang@intel.com>
Subject: [PATCH] modify the IO_TLB_SEGSIZE to configtable as flexible requirement about IOMMU/SW-IOMMU.
Date: Tue, 27 Jan 2015 03:30:21 +0800
Message-Id: <1422300621-4453-1-git-send-email-xiaoming.wang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The maximum of SW-IOMMU is limited to 2^11*128 = 256K.
While in different platform and different requirements this seems improper.
So modify the IO_TLB_SEGSIZE to configtable is make sense.
Example:
If 1M bytes are requied. There has an error like.
[ 33.293120] DMA: Out of SW-IOMMU space for 1048576 bytes at device gadget

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
Signed-off-by: xiaomin1 <xiaoming.wang@intel.com>
---
 include/linux/swiotlb.h |    2 +-
 lib/Kconfig             |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index e7a018e..5ab10b9 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -14,7 +14,7 @@ extern int swiotlb_force;
  * must be a power of 2.  What is the appropriate value ?
  * The complexity of {map,unmap}_single is linearly dependent on this value.
  */
-#define IO_TLB_SEGSIZE	128
+#define IO_TLB_SEGSIZE	CONFIG_DEFAULT_IO_TLB_SEGSIZE
 
 /*
  * log of the size of each IO TLB slab.  The number of slabs is command line
diff --git a/lib/Kconfig b/lib/Kconfig
index 54cf309..76f1108 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -518,4 +518,8 @@ source "lib/fonts/Kconfig"
 config ARCH_HAS_SG_CHAIN
 	def_bool n
 
+config DEFAULT_IO_TLB_SEGSIZE
+	int
+	default 128
+
 endmenu
-- 
1.7.9.5


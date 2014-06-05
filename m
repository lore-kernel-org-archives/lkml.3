Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaFEWTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:19:53 -0400
Received: from mxip5-inbound.gatech.edu ([130.207.182.47]:33801 "EHLO
	mxip5-inbound.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbaFEWTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:19:52 -0400
X-RemoteIP: 130.207.185.166
X-Group: ZimbraSenderGroup
X-Policy: $ZIMBRA
X-MID: 91933656
X-SBRS: None
X-IronPort-AV: E=Sophos;i="4.98,984,1392181200"; 
   d="scan'208";a="91933656"
X-GT-Spam-Rating: (0%)
Message-ID: <5390ED07.2070009@gatech.edu>
Date: Thu, 05 Jun 2014 18:19:51 -0400
From: Pranith Kumar <pranith@gatech.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: dwmw2@infradead.org, joro@8bytes.org
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] use documented cmpxchg api
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use the documented atomic_cmpxchg instead of __cmpxchg64

This kills the last user of said API in drivers code.


Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 drivers/iommu/intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 6bb3277..270113f 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -293,7 +293,7 @@ static inline u64 dma_pte_addr(struct dma_pte *pte)
 	return pte->val & VTD_PAGE_MASK;
 #else
 	/* Must have a full atomic 64-bit read */
-	return  __cmpxchg64(&pte->val, 0ULL, 0ULL) & VTD_PAGE_MASK;
+	return  atomic_cmpxchg(&pte->val, 0ULL, 0ULL) & VTD_PAGE_MASK;
 #endif
 }
 
-- 
1.7.9.5

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaIYUd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 16:33:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:2411 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbaIYUd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 16:33:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,599,1406617200"; 
   d="scan'208";a="596939689"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v11 01/21] axonram: Fix bug in direct_access
Date: Thu, 25 Sep 2014 16:33:18 -0400
Message-Id: <1411677218-29146-2-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'pfn' returned by axonram was completely bogus, and has been since
2008.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 arch/powerpc/sysdev/axonram.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index 47b6b9f..830edc8 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -156,7 +156,7 @@ axon_ram_direct_access(struct block_device *device, sector_t sector,
 	}
 
 	*kaddr = (void *)(bank->ph_addr + offset);
-	*pfn = virt_to_phys(kaddr) >> PAGE_SHIFT;
+	*pfn = virt_to_phys(*kaddr) >> PAGE_SHIFT;
 
 	return 0;
 }
-- 
2.1.0


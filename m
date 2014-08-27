Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323AbaH0Ehm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 00:37:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:19005 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbaH0Eeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 00:34:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,408,1406617200"; 
   d="scan'208";a="593818328"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, willy@linux.intel.com
Subject: [PATCH v10 01/21] axonram: Fix bug in direct_access
Date: Tue, 26 Aug 2014 23:45:21 -0400
Message-Id: <58b32b560c75cb4ec7beb75502484919b556d394.1409110741.git.matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <cover.1409110741.git.matthew.r.wilcox@intel.com>
References: <cover.1409110741.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1409110741.git.matthew.r.wilcox@intel.com>
References: <cover.1409110741.git.matthew.r.wilcox@intel.com>
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
2.0.0


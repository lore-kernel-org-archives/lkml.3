Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab3JLWB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 18:01:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36970 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab3JLWAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 18:00:14 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <tj@kernel.org>, <yinghai@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <grygorii.strashko@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC 23/23] mm/ARM: OMAP: Use memblock apis for early memory allocations
Date: Sat, 12 Oct 2013 17:59:06 -0400
Message-ID: <1381615146-20342-24-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381615146-20342-1-git-send-email-santosh.shilimkar@ti.com>
References: <1381615146-20342-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to memblock interfaces for early memory allocator

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index d9ee0ff..adfd6a2 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -2676,9 +2676,7 @@ static int __init _alloc_links(struct omap_hwmod_link **ml,
 	sz = sizeof(struct omap_hwmod_link) * LINKS_PER_OCP_IF;
 
 	*sl = NULL;
-	*ml = alloc_bootmem(sz);
-
-	memset(*ml, 0, sz);
+	*ml = memblock_early_alloc(sz);
 
 	*sl = (void *)(*ml) + sizeof(struct omap_hwmod_link);
 
@@ -2797,9 +2795,7 @@ static int __init _alloc_linkspace(struct omap_hwmod_ocp_if **ois)
 	pr_debug("omap_hwmod: %s: allocating %d byte linkspace (%d links)\n",
 		 __func__, sz, max_ls);
 
-	linkspace = alloc_bootmem(sz);
-
-	memset(linkspace, 0, sz);
+	linkspace = memblock_early_alloc(sz);
 
 	return 0;
 }
-- 
1.7.9.5


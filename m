Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966988Ab3E2PJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:09:26 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:50867 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966955Ab3E2PJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:09:23 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH, v2 4/5] mm/microblaze: clean up unused VALID_PAGE()
Date: Wed, 29 May 2013 23:08:55 +0800
Message-Id: <1369840136-1491-5-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369840136-1491-1-git-send-email-jiang.liu@huawei.com>
References: <1369840136-1491-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VALID_PAGE() has been removed from kernel long time ago, so clean up it.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au
Cc: linux-kernel@vger.kernel.org
---
 arch/microblaze/include/asm/page.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/microblaze/include/asm/page.h b/arch/microblaze/include/asm/page.h
index 85a5ae8..fd85087 100644
--- a/arch/microblaze/include/asm/page.h
+++ b/arch/microblaze/include/asm/page.h
@@ -168,7 +168,6 @@ extern int page_is_ram(unsigned long pfn);
 #  else /* CONFIG_MMU */
 #  define ARCH_PFN_OFFSET	(memory_start >> PAGE_SHIFT)
 #  define pfn_valid(pfn)	((pfn) < (max_mapnr + ARCH_PFN_OFFSET))
-#  define VALID_PAGE(page) 	((page - mem_map) < max_mapnr)
 #  endif /* CONFIG_MMU */
 
 # endif /* __ASSEMBLY__ */
-- 
1.8.1.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966954Ab3E2PJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:09:16 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:58557 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966297Ab3E2PJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:09:13 -0400
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
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-alpha@vger.kernel.org
Subject: [PATCH, v2 1/5] mm/ALPHA: clean up unused VALID_PAGE()
Date: Wed, 29 May 2013 23:08:52 +0800
Message-Id: <1369840136-1491-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369840136-1491-1-git-send-email-jiang.liu@huawei.com>
References: <1369840136-1491-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VALID_PAGE() has been removed from kernel long time ago, so clean up it.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: linux-alpha@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/alpha/include/asm/mmzone.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/alpha/include/asm/mmzone.h b/arch/alpha/include/asm/mmzone.h
index c5b5d6b..14ce27b 100644
--- a/arch/alpha/include/asm/mmzone.h
+++ b/arch/alpha/include/asm/mmzone.h
@@ -71,8 +71,6 @@ PLAT_NODE_DATA_LOCALNR(unsigned long p, int n)
 
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
 
-#define VALID_PAGE(page)	(((page) - mem_map) < max_mapnr)
-
 #define pmd_page(pmd)		(pfn_to_page(pmd_val(pmd) >> 32))
 #define pgd_page(pgd)		(pfn_to_page(pgd_val(pgd) >> 32))
 #define pte_pfn(pte)		(pte_val(pte) >> 32)
-- 
1.8.1.2


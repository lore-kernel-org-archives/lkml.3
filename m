Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab3DMPma (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 11:42:30 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:54503 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607Ab3DMPm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 11:42:26 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, David Howells <dhowells@redhat.com>,
        Mark Salter <msalter@redhat.com>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [RFC PATCH v1 13/19] mm/CRIS: clean up unused VALID_PAGE()
Date: Sat, 13 Apr 2013 23:36:33 +0800
Message-Id: <1365867399-21323-14-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365867399-21323-1-git-send-email-jiang.liu@huawei.com>
References: <1365867399-21323-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VALID_PAGE() has been removed from kernel long time ago, so clean up it.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: linux-cris-kernel@axis.com
Cc: linux-kernel@vger.kernel.org
---
 arch/cris/include/asm/page.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/cris/include/asm/page.h b/arch/cris/include/asm/page.h
index be45ee3..dfc53f9 100644
--- a/arch/cris/include/asm/page.h
+++ b/arch/cris/include/asm/page.h
@@ -51,7 +51,6 @@ typedef struct page *pgtable_t;
  */ 
 
 #define virt_to_page(kaddr)    (mem_map + (((unsigned long)(kaddr) - PAGE_OFFSET) >> PAGE_SHIFT))
-#define VALID_PAGE(page)       (((page) - mem_map) < max_mapnr)
 #define virt_addr_valid(kaddr)	pfn_valid((unsigned)(kaddr) >> PAGE_SHIFT)
 
 /* convert a page (based on mem_map and forward) to a physical address
-- 
1.7.9.5


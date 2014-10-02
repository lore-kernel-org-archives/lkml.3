Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbaJBPtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:49:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38886 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbaJBPtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:49:41 -0400
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Mel Gorman <mgorman@suse.de>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Rik van Riel <riel@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Xishi Qiu <qiuxishi@huawei.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: [PATCH 0/4] Single zone pcpclists drain
Date: Thu,  2 Oct 2014 17:48:56 +0200
Message-Id: <1412264940-15738-1-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small series is an optimization of pcplists draining. In many cases, it
is sufficient to drain pcplists of a single zone, and draining all zones is
a waste of cycles, and then it results in more pcplists refilling.

Patch 1 introduces "struct zone *" parameter to drain_local_pages() and
drain_all_pages(), where NULL value means that all zones are drained as usual.
Remaining patches convert existing callers to single zone drain where
appropriate. One might wonder why compaction is not touched, and the answer
is that it will be posted later, as it's a larger change.

Vlastimil Babka (4):
  mm: introduce single zone pcplists drain
  mm, page_isolation: drain single zone pcplists
  mm, cma: drain single zone pcplists
  mm, memory_hotplug/failure: drain single zone pcplists

 include/linux/gfp.h |  4 +--
 mm/memory-failure.c |  4 +--
 mm/memory_hotplug.c |  4 +--
 mm/page_alloc.c     | 81 ++++++++++++++++++++++++++++++++++++-----------------
 mm/page_isolation.c |  2 +-
 5 files changed, 63 insertions(+), 32 deletions(-)

-- 
1.8.4.5


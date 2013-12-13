Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab3LMGud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 01:50:33 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:52563 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab3LMGuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 01:50:32 -0500
X-AuditID: 9c93017e-b7c17ae000003961-c1-52aaae35abc2
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <js1304@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v3 0/6] correct and clean-up migration related stuff
Date: Fri, 13 Dec 2013 15:53:25 +0900
Message-Id: <1386917611-11319-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes From v2
- Drop 7th patch which try to remove result argument on page allocation
function for migration since it is wrong.
- Fix one missed word on changelog for 2nd patch, "correct failure
handling if !hugepage_migration_support()"
- Remove missed callsite for putback_lru_pages() on 4th patch
- Add Acked-by and Review-by

Here is the patchset for correcting and cleaning-up migration
related stuff. These are random correction and clean-up, so
please see each patches ;)

Thanks.

Naoya Horiguchi (1):
  mm/migrate: add comment about permanent failure path

Joonsoo Kim (5):
  mm/migrate: correct failure handling if !hugepage_migration_support()
  mm/mempolicy: correct putback method for isolate pages if failed
  mm/migrate: remove putback_lru_pages, fix comment on
    putback_movable_pages
  mm/compaction: respect ignore_skip_hint in update_pageblock_skip
  mm/migrate: remove unused function, fail_migrate_page()

 include/linux/migrate.h |    6 ------
 mm/compaction.c         |    4 ++++
 mm/memory-failure.c     |    8 +++++++-
 mm/mempolicy.c          |    2 +-
 mm/migrate.c            |   51 +++++++++++++++++++----------------------------
 5 files changed, 32 insertions(+), 39 deletions(-)

-- 
1.7.9.5


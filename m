Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760973Ab3LIJIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:08:06 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:63850 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760750Ab3LIJIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:08:00 -0500
X-AuditID: 9c93017d-b7b46ae000000e86-b1-52a5886f2fd9
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <js1304@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 0/7] correct and clean-up migration related stuff
Date: Mon,  9 Dec 2013 18:10:41 +0900
Message-Id: <1386580248-22431-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the patchset for correcting and cleaning-up migration
related stuff. These are random correction and clean-up, so
please see each patches ;)

Thanks.

Naoya Horiguchi (1):
  mm/migrate: add comment about permanent failure path

Joonsoo Kim (6):
  mm/migrate: correct failure handling if !hugepage_migration_support()
  mm/mempolicy: correct putback method for isolate pages if failed
  mm/migrate: remove putback_lru_pages, fix comment on
    putback_movable_pages
  mm/compaction: respect ignore_skip_hint in update_pageblock_skip
  mm/migrate: remove unused function, fail_migrate_page()
  mm/migrate: remove result argument on page allocation function for
    migration

 include/linux/migrate.h        |    8 +----
 include/linux/page-isolation.h |    3 +-
 mm/compaction.c                |    7 ++--
 mm/memory-failure.c            |   10 ++++--
 mm/mempolicy.c                 |    8 ++---
 mm/migrate.c                   |   74 +++++++++++++---------------------------
 mm/page_isolation.c            |    3 +-
 7 files changed, 44 insertions(+), 69 deletions(-)

-- 
1.7.9.5


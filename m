Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaLHHNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 02:13:35 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:34144 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaLHHMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 02:12:36 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 0/4] enhance compaction success rate
Date: Mon,  8 Dec 2014 16:16:16 +0900
Message-Id: <1418022980-4584-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset aims at increase of compaction success rate. Changes are
related to compaction finish condition and freepage isolation condition.

>From these changes, I did stress highalloc test in mmtests with nonmovable
order 7 allocation configuration, and success rate (%) at phase 1 are,

Base	Patch-1	Patch-3	Patch-4
55.00	57.00	62.67	64.00

And, compaction success rate (%) on same test are,

Base	Patch-1	Patch-3	Patch-4
18.47	28.94	35.13	41.50

This patchset is based on my tracepoint update on compaction.

https://lkml.org/lkml/2014/12/3/71

Joonsoo Kim (4):
  mm/compaction: fix wrong order check in compact_finished()
  mm/page_alloc: expands broken freepage to proper buddy list when
    steal
  mm/compaction: enhance compaction finish condition
  mm/compaction: stop the isolation when we isolate enough freepage

 include/linux/mmzone.h      |    3 ++
 include/trace/events/kmem.h |    7 +++--
 mm/compaction.c             |   48 ++++++++++++++++++++++------
 mm/internal.h               |    1 +
 mm/page_alloc.c             |   73 +++++++++++++++++++++++++------------------
 5 files changed, 89 insertions(+), 43 deletions(-)

-- 
1.7.9.5


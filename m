Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbaCZP2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 11:28:12 -0400
Received: from relay.parallels.com ([195.214.232.42]:41847 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbaCZP2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 11:28:10 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <glommer@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>
Subject: [PATCH -mm 0/4] kmemcg: get rid of __GFP_KMEMCG
Date: Wed, 26 Mar 2014 19:28:03 +0400
Message-ID: <cover.1395846845.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently we charge kmem to memcg in alloc_pages if __GFP_KMEMCG is
passed. However, since there are only a few places where we actually
want to charge kmem, we could call kmemcg charge function explicitly
instead. That would remove all kmemcg-related stuff from the general
allocation path and make all kmem charges easier to follow.

So let's charge kmem explicitly where we want it to be charged (slab,
threadinfo) and remove __GFP_KMEMCG.

Thanks,

Vladimir Davydov (4):
  sl[au]b: do not charge large allocations to memcg
  sl[au]b: charge slabs to memcg explicitly
  fork: charge threadinfo to memcg explicitly
  mm: kill __GFP_KMEMCG

 include/linux/gfp.h             |    5 -----
 include/linux/memcontrol.h      |   26 +++++++++++++-----------
 include/linux/slab.h            |    2 +-
 include/linux/thread_info.h     |    2 --
 include/trace/events/gfpflags.h |    1 -
 kernel/fork.c                   |   13 +++++++++---
 mm/memcontrol.c                 |   42 +++++++++++++++------------------------
 mm/page_alloc.c                 |   35 --------------------------------
 mm/slab.c                       |    7 ++++++-
 mm/slab_common.c                |    6 +-----
 mm/slub.c                       |   28 +++++++++++++++++---------
 11 files changed, 67 insertions(+), 100 deletions(-)

-- 
1.7.10.4


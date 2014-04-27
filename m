Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaD0JEP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 05:04:15 -0400
Received: from relay.parallels.com ([195.214.232.42]:35024 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbaD0JEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 05:04:13 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <mhocko@suse.cz>, <hannes@cmpxchg.org>, <glommer@gmail.com>,
        <cl@linux-foundation.org>, <penberg@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>
Subject: [PATCH -mm v2 0/6] memcg/kmem: cleanup naming and callflows
Date: Sun, 27 Apr 2014 13:04:02 +0400
Message-ID: <cover.1398587474.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.25.110]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In reply to "[PATCH RFC -mm v2 3/3] memcg, slab: simplify
synchronization scheme" Johannes wrote:

> I like this patch, but the API names are confusing. Could we fix up
> that whole thing by any chance?

(see https://lkml.org/lkml/2014/4/18/317)

So this patch set is about cleaning up memcg/kmem naming.

While preparing it I found that some of the ugly-named functions
constituting interface between memcontrol.c and slab_common.c can be
neatly got rid of w/o complicating the code. Quite the contrary, w/o
them call-flows look much simpler, IMO. So the first four patches do not
rename anything actually - they just rework call-flows in kmem cache
creation/destruction and memcg_caches arrays relocations paths. Finally,
patches 5 and 6 clean up the naming.

v1: http://lkml.org/lkml/2014/4/25/254

Changes in v2:
 - move memcg_params allocation/free for per memcg caches to
   slab_common.c, because this way it looks clearer (patch 4)
 - minor changes in function names and comments

Reviews are appreciated.

Thanks,

Vladimir Davydov (6):
  memcg: get rid of memcg_create_cache_name
  memcg: allocate memcg_caches array on first per memcg cache creation
  memcg: cleanup memcg_caches arrays relocation path
  memcg: get rid of memcg_{alloc,free}_cache_params
  memcg: cleanup kmem cache creation/destruction functions naming
  memcg: cleanup kmem_id-related naming

 include/linux/memcontrol.h |   40 +----
 include/linux/slab.h       |   11 +-
 mm/memcontrol.c            |  396 +++++++++++++++++++-------------------------
 mm/slab.c                  |    4 +-
 mm/slab.h                  |   24 ++-
 mm/slab_common.c           |  148 ++++++++++++-----
 mm/slub.c                  |   10 +-
 7 files changed, 314 insertions(+), 319 deletions(-)

-- 
1.7.10.4


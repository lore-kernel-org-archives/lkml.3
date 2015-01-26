Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbbAZMzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:55:48 -0500
Received: from mx2.parallels.com ([199.115.105.18]:55906 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbbAZMzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:55:40 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm 0/3] slub: make dead caches discard free slabs immediately
Date: Mon, 26 Jan 2015 15:55:26 +0300
Message-ID: <cover.1422275084.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The kmem extension of the memory cgroup is almost usable now. There is,
in fact, the only serious issue left: per memcg kmem caches may pin the
owner cgroup for indefinitely long. This is, because a slab cache may
keep empty slab pages in its private structures to optimize performance,
while we take a css reference per each charged kmem page.

The issue is only relevant to SLUB, because SLAB periodically reaps
empty slabs. This patch set fixes this issue for SLUB. For details,
please see patch 3.

Thanks,

Vladimir Davydov (3):
  slub: don't fail kmem_cache_shrink if slab placement optimization
    fails
  slab: zap kmem_cache_shrink return value
  slub: make dead caches discard free slabs immediately

 include/linux/slab.h |    2 +-
 mm/slab.c            |    9 +++++++--
 mm/slab.h            |    2 +-
 mm/slab_common.c     |   21 +++++++++++++-------
 mm/slob.c            |    3 +--
 mm/slub.c            |   53 +++++++++++++++++++++++++++++++++++---------------
 6 files changed, 61 insertions(+), 29 deletions(-)

-- 
1.7.10.4


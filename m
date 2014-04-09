Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675AbaDIPCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:02:40 -0400
Received: from relay.parallels.com ([195.214.232.42]:46499 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978AbaDIPCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:02:38 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <mhocko@suse.cz>, <hannes@cmpxchg.org>, <glommer@gmail.com>,
        <cl@linux-foundation.org>, <penberg@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>
Subject: [PATCH -mm 0/4] memcg-vs-slab cleanup
Date: Wed, 9 Apr 2014 19:02:29 +0400
Message-ID: <cover.1397054470.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset does a bit of cleanup in the kmemcg implementation
hopefully making it more readable.

It requires the following two patches applied on top of the mmotm tree:
  [PATCH -mm v2 1/2] sl[au]b: charge slabs to kmemcg explicitly
  [PATCH -mm v2.2] mm: get rid of __GFP_KMEMCG
(see https://lkml.org/lkml/2014/4/1/100)

Thanks,

Vladimir Davydov (4):
  memcg, slab: do not schedule cache destruction when last page goes
    away
  memcg, slab: merge memcg_{bind,release}_pages to
    memcg_{un}charge_slab
  memcg, slab: change memcg::slab_caches_mutex vs slab_mutex locking
    order
  memcg, slab: remove memcg_cache_params::destroy work

 include/linux/memcontrol.h |   15 +---
 include/linux/slab.h       |    8 +-
 mm/memcontrol.c            |  209 +++++++++++++++++---------------------------
 mm/slab.c                  |    2 -
 mm/slab.h                  |   28 +-----
 mm/slab_common.c           |   22 ++---
 mm/slub.c                  |    2 -
 7 files changed, 94 insertions(+), 192 deletions(-)

-- 
1.7.10.4


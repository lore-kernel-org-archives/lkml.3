Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831AbaEMNs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:48:58 -0400
Received: from relay.parallels.com ([195.214.232.42]:49683 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760176AbaEMNsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:48:55 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <cl@linux-foundation.org>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH RFC 0/3] kmemcg slab reparenting
Date: Tue, 13 May 2014 17:48:50 +0400
Message-ID: <cover.1399982635.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes, Michal, Christoph,

Recently I posted my thoughts on how we can handle kmem caches of dead
memcgs:

https://lkml.org/lkml/2014/4/20/38

The only feedback I got then was from Johannes who voted for migrating
slabs of such caches to the parent memcg's cache (so called
reparenting), so in this RFC I'd like to propose a draft of possible
implementation of slab reparenting. I'd appreciate if you could look
through it and post if it's worth developing in this direction or not.

The implementation of reparenting is given in patch 3, which is the most
important part of this set. Patch 1 just makes slub keep full slabs on
list, and patch 2 a bit extends percpu-refcnt interface.

NOTE the implementation is given only for slub, though it should be easy
to implement the same hack for slab.

Thanks,

Vladimir Davydov (3):
  slub: keep full slabs on list for per memcg caches
  percpu-refcount: allow to get dead reference
  slub: reparent memcg caches' slabs on memcg offline

 include/linux/memcontrol.h      |    4 +-
 include/linux/percpu-refcount.h |   11 +-
 include/linux/slab.h            |    7 +-
 mm/memcontrol.c                 |   54 ++++---
 mm/slab.h                       |    7 +-
 mm/slub.c                       |  299 ++++++++++++++++++++++++++++++++++-----
 6 files changed, 318 insertions(+), 64 deletions(-)

-- 
1.7.10.4


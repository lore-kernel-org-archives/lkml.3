Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbaJNQUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:20:50 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:41857 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932386AbaJNQUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:20:49 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 0/5] mm: memcontrol: eliminate charge reparenting v2
Date: Tue, 14 Oct 2014 12:20:32 -0400
Message-Id: <1413303637-23862-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series gets rid of charge reparenting at cgroup deletion, which
is possible now that the css can outlive the user-visible cgroup.  Any
cache charges left after cgroup deletion simply remain with their css,
where they continue to get reclaimed during pressure on the parent.

Version 2:

    - remove memcg->dead_count [vladimir]
    - restore iterator generations [vladimir]
    - restore memcg-initialized test [michal]
    - document shared walk lockless magic [michal]
    - split out sync stock draining removal [michal]

 include/linux/cgroup.h          |  26 ++
 include/linux/page_counter.h    |   4 +-
 include/linux/percpu-refcount.h |  47 ++-
 mm/memcontrol.c                 | 593 ++++++--------------------------------
 mm/page_counter.c               |  23 +-
 5 files changed, 163 insertions(+), 530 deletions(-)


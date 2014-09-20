Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbaITUAw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 16:00:52 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:48107 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691AbaITUAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 16:00:50 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>,
        Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/3] mm: memcontrol: eliminate charge reparenting
Date: Sat, 20 Sep 2014 16:00:32 -0400
Message-Id: <1411243235-24680-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we've come a looong way when it comes to the basic cgroups model, and
the recent changes there open up a lot of opportunity to make drastic
simplifications to memory cgroups as well.

The decoupling of css from the user-visible cgroup, word-sized per-cpu
css reference counters, and css iterators that include offlined groups
means we can take per-charge css references, continue to reclaim from
offlined groups, and so get rid of the error-prone charge reparenting.

Combined with the higher-order reclaim fixes, lockless page counters,
and memcg iterator simplification I sent on Friday, the memory cgroup
core code is finally no longer the biggest file in mm/.  Yay!

These patches are based on mmotm + the above-mentioned changes + Tj's
percpu-refcount conversion to atomic_long_t.

Thanks!

 include/linux/cgroup.h          |  26 +++
 include/linux/percpu-refcount.h |  43 ++++-
 mm/memcontrol.c                 | 337 ++------------------------------------
 3 files changed, 75 insertions(+), 331 deletions(-)


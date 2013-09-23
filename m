Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab3IWI4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:56:21 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:31290 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab3IWI4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:56:19 -0400
Message-ID: <524001F8.6070205@huawei.com>
Date: Mon, 23 Sep 2013 16:55:20 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH v6 0/5] memcg, cgroup: kill css id
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The whole patchset has been acked and reviewed by Michal and Tejun.
Could you merge it into mm tree?

===========

This patchset converts memcg to use cgroup->id, and then we remove cgroup
css_id.

As we've removed memcg's own refcnt, converting memcg to use cgroup->id
is very straight-forward.

v6:
- rebased against mmotm 2013-09-20-15-59
- moved cgroup id check from mem_cgroup_css_alloc() to mem_cgroup_css_online()

v5:
- rebased against mmotm 2013-08-07-16-55

v4:
- make cgroup_from_id() inline and check if cgroup_mutex is held.
- add a comment for idr_remove() in cgroup_offline)fn().

v2->v3:
- some minor cleanups suggested by Michal.
- fixed the call to idr_alloc() in cgroup_init() in the first patch.

Li Zefan (5):
  memcg: convert to use cgroup_is_descendant()
  memcg: convert to use cgroup id
  memcg: fail to create cgroup if the cgroup id is too big
  memcg: stop using css id
  cgroup: kill css_id

 include/linux/cgroup.h |  37 --------
 kernel/cgroup.c        | 248 +------------------------------------------------
 mm/memcontrol.c        |  66 +++++++------
 3 files changed, 41 insertions(+), 310 deletions(-)

-- 
1.8.0.2

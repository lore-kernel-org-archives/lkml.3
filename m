Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933477Ab3HHCdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:33:10 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:61898 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796Ab3HHCdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:33:08 -0400
Message-ID: <52030346.4050003@huawei.com>
Date: Thu, 8 Aug 2013 10:32:38 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH v5 0/5] memcg, cgroup: kill css_id
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

All the cgroup preparation patches are in cgroup tree now, and these
remaining patches can be routed by mm tree.

===========

This patchset converts memcg to use cgroup->id, and then we can remove
cgroup css_id.

As we've removed memcg's own refcnt, converting memcg to use cgroup->id
is very straight-forward.

The patchset is based on Tejun's cgroup tree.

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

--
 include/linux/cgroup.h |  37 ----------
 kernel/cgroup.c        | 252 +---------------------------------------------------------------
 mm/memcontrol.c        |  69 +++++++++++-------
 3 files changed, 43 insertions(+), 315 deletions(-)

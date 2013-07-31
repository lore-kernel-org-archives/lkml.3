Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794Ab3GaBvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 21:51:23 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:25670 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab3GaBvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 21:51:21 -0400
Message-ID: <51F86D69.2030907@huawei.com>
Date: Wed, 31 Jul 2013 09:50:33 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH v4 0/8] memcg, cgroup: kill css_id
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset converts memcg to use cgroup->id, and then we can remove
cgroup css_id.

As we've removed memcg's own refcnt, converting memcg to use cgroup->id
is very straight-forward.

The patchset is based on Tejun's cgroup tree.

v4:
- make cgroup_from_id() inline and check if cgroup_mutex is held.
- add a comment for idr_remove() in cgroup_offline)fn().

v2->v3:
- some minor cleanups suggested by Michal.
- fixed the call to idr_alloc() in cgroup_init() in the first patch.

Li Zefan (8):
      cgroup: convert cgroup_ida to cgroup_idr
      cgroup: document how cgroup IDs are assigned
      cgroup: implement cgroup_from_id()
      memcg: convert to use cgroup_is_descendant()
      memcg: convert to use cgroup id
      memcg: fail to create cgroup if the cgroup id is too big
      memcg: stop using css id
      cgroup: kill css_id
--
 include/linux/cgroup.h |  65 ++++++--------
 kernel/cgroup.c        | 285 ++++++-----------------------------------------------------
 mm/memcontrol.c        |  68 ++++++++------
 3 files changed, 96 insertions(+), 322 deletions(-)

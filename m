Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab3G2HIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 03:08:39 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:36241 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab3G2HIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 03:08:36 -0400
Message-ID: <51F614B2.6010503@huawei.com>
Date: Mon, 29 Jul 2013 15:07:30 +0800
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
Subject: [PATCH v3 0/8] memcg, cgroup: kill css_id
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
 include/linux/cgroup.h |  49 ++--------
 kernel/cgroup.c        | 296 ++++++++---------------------------------------------------
 mm/memcontrol.c        |  68 ++++++++------
 3 files changed, 91 insertions(+), 322 deletions(-)

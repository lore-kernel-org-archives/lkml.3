Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934880Ab3DHIU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 04:20:57 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:61088 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934546Ab3DHIUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 04:20:55 -0400
Message-ID: <51627DA9.7020507@huawei.com>
Date: Mon, 8 Apr 2013 16:19:53 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH 0/8] memcg, cgroup: kill css_id
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This patchset depends on "memcg: make memcg's life cycle the same as cgroup")

This patchset converts memcg to always use cgroup->id, and then kills
css_id.

As we've removed memcg's own refcnt, converting memcg to use cgroup->id
is very straight-forward.

Li Zefan (8):
      cgroup: implement cgroup_is_ancestor()
      cgroup: implement cgroup_from_id()
      memcg: convert to use cgroup_is_ancestor()
      memcg: convert to use cgroup_from_id()
      memcg: convert to use cgroup->id
      memcg: fail to create cgroup if the cgroup id is too big
      memcg: don't use css_id any more
      cgroup: kill css_id

--
 include/linux/cgroup.h |  44 ++-------
 kernel/cgroup.c        | 302 +++++++++-----------------------------------------------------
 mm/memcontrol.c        |  53 ++++++-----
 3 files changed, 77 insertions(+), 322 deletions(-)

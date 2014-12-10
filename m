Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448AbaLJRIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:08:42 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:34708 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904AbaLJRIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:08:31 -0500
Date: Wed, 10 Dec 2014 12:08:27 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        cgroups@vger.kernel.org
Subject: [GIT PULL] cgroup changes for v3.19-rc1
Message-ID: <20141210170827.GE6294@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

cpuset got simplified a bit.  cgroup core got a fix on unified
hierarchy and grew some effective css related interfaces which will be
used for blkio support for writeback IO traffic which is currently
being worked on.

Thanks.

The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.19

for you to fetch changes up to eeecbd1971517103e06f11750dd1a9a1dc37e4e6:

  cgroup: implement cgroup_get_e_css() (2014-11-18 02:49:52 -0500)

----------------------------------------------------------------
Dan Carpenter (1):
      cpuset: lock vs unlock typo

Tejun Heo (6):
      cgroup: separate out cgroup_calc_child_subsys_mask() from cgroup_refresh_child_subsys_mask()
      cgroup: restructure child_subsys_mask handling in cgroup_subtree_control_write()
      cgroup: fix the async css offline wait logic in cgroup_subtree_control_write()
      cgroup: add cgroup_subsys->css_released()
      cgroup: add cgroup_subsys->css_e_css_changed()
      cgroup: implement cgroup_get_e_css()

Vladimir Davydov (2):
      cpuset: convert callback_mutex to a spinlock
      cpuset: simplify cpuset_node_allowed API

 include/linux/cgroup.h |   4 ++
 include/linux/cpuset.h |  37 ++---------
 kernel/cgroup.c        | 175 ++++++++++++++++++++++++++++++++++---------------
 kernel/cpuset.c        | 162 ++++++++++++++++-----------------------------
 mm/hugetlb.c           |   2 +-
 mm/oom_kill.c          |   2 +-
 mm/page_alloc.c        |   6 +-
 mm/slab.c              |   2 +-
 mm/slub.c              |   3 +-
 mm/vmscan.c            |   5 +-
 10 files changed, 200 insertions(+), 198 deletions(-)

-- 
tejun

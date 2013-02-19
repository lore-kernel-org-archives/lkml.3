Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933731Ab3BSSlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:41:05 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35765 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823Ab3BSSlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:41:00 -0500
Date: Tue, 19 Feb 2013 10:40:55 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: [GIT PULL] cpuset changes for 3.9-rc1
Message-ID: <20130219184055.GR17414@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

This is cpuset changes for 3.9-rc1.

* Synchornization has seen a lot of changes with focus on decoupling
  cpuset synchronization from cgroup internal locking.  After this
  change, there only remain a couple of mostly trivial dependencies on
  cgroup_lock outside cgroup core proper.  cgroup_lock is scheduled to
  be unexported in this devel cycle.  This will finally remove the
  fragile locking order around cgroup (cgroup locking wants to /
  should be one of the outermost but yet has been acquired from deep
  inside individual controllers).

* At this point, Li is most knowlegeable with cpuset and taking over
  the maintainership of cpuset.

This depends on cgroup_rightmost_descendant() implemented in
cgroup/for-3.9 and this pull request assumes that cgroup/for-3.9 is
already pulled in.

The changes are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.9-cpuset

for you to fetch changes up to d127027baf98dce3ca31bec18c2c0e048ceda7c4:

  cpuset: drop spurious retval assignment in proc_cpuset_show() (2013-01-15 08:38:55 -0800)

----------------------------------------------------------------
Li Zefan (3):
      cpuset: update MAINTAINERS
      cpuset: fix RCU lockdep splat
      cpuset: drop spurious retval assignment in proc_cpuset_show()

Tejun Heo (15):
      cpuset: remove unused cpuset_unlock()
      cpuset: remove fast exit path from remove_tasks_in_empty_cpuset()
      cpuset: introduce ->css_on/offline()
      cpuset: introduce CS_ONLINE
      cpuset: introduce cpuset_for_each_child()
      cpuset: cleanup cpuset[_can]_attach()
      cpuset: reorganize CPU / memory hotplug handling
      cpuset: don't nest cgroup_mutex inside get_online_cpus()
      cpuset: drop async_rebuild_sched_domains()
      cpuset: make CPU / memory hotplug propagation asynchronous
      cpuset: pin down cpus and mems while a task is being attached
      cpuset: schedule hotplug propagation from cpuset_attach() if the cpuset is empty
      cpuset: replace cgroup_mutex locking with cpuset internal locking
      cpuset: replace cpuset->stack_list with cpuset_for_each_descendant_pre()
      cpuset: remove cpuset->parent

 MAINTAINERS     |   4 +-
 kernel/cpuset.c | 872 +++++++++++++++++++++++++++++++-------------------------
 2 files changed, 485 insertions(+), 391 deletions(-)

Thanks.

--
tejun

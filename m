Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565Ab3BSSdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:33:00 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46083 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab3BSSc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:32:57 -0500
Date: Tue, 19 Feb 2013 10:32:53 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: [GIT PULL] cgroup changes for 3.9-rc1
Message-ID: <20130219183253.GQ17414@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

These are cgroup changes for 3.9-rc1.  Nothing too drastic.

* Removal of synchronize_rcu() from userland visible paths.

* Various fixes and cleanups from Li.

* cgroup_rightmost_descendant() added which will be used by cpuset
  changes (it will be a separate pull request).

The changes are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.9

for you to fetch changes up to f169007b2773f285e098cb84c74aac0154d65ff7:

  cgroup: fail if monitored file and event_control are in different cgroup (2013-02-18 09:31:35 -0800)

----------------------------------------------------------------
Greg Thelen (2):
      cgroups: move cgroup_event_listener.c to tools/cgroup
      cgroups: fix cgroup_event_listener error handling

Li Zefan (15):
      cgroup: use new hashtable implementation
      cgroup: remove synchronize_rcu() from cgroup_attach_{task|proc}()
      cgroup: remove synchronize_rcu() from rebind_subsystems()
      cgroup: fix bogus kernel warnings when cgroup_create() failed
      cgroup: remove a NULL check in cgroup_exit()
      cgroup: initialize cgrp->dentry before css_alloc()
      sched: split out css_online/css_offline from tg creation/destruction
      sched: remove redundant NULL cgroup check in task_group_path()
      cgroup: remove duplicate RCU free on struct cgroup
      cgroup: remove synchronize_rcu() from cgroup_diput()
      cgroup: remove bogus comments in cgroup_diput()
      cgroup: fix exit() vs rmdir() race
      cpuset: fix cpuset_print_task_mems_allowed() vs rename() race
      cgroup: fix cgroup_rmdir() vs close(eventfd) race
      cgroup: fail if monitored file and event_control are in different cgroup

Tejun Heo (2):
      cgroup: remove unused dummy cgroup_fork_callbacks()
      cgroup: implement cgroup_rightmost_descendant()

 Documentation/cgroups/00-INDEX                     |   2 -
 Documentation/cgroups/memcg_test.txt               |   3 +-
 include/linux/cgroup.h                             |   3 +-
 include/linux/sched.h                              |   3 +
 kernel/cgroup.c                                    | 288 ++++++++++++---------
 kernel/cpuset.c                                    |  12 +-
 kernel/sched/auto_group.c                          |   3 +
 kernel/sched/core.c                                |  49 +++-
 kernel/sched/debug.c                               |   7 -
 tools/Makefile                                     |  19 +-
 tools/cgroup/.gitignore                            |   1 +
 tools/cgroup/Makefile                              |  11 +
 .../cgroup}/cgroup_event_listener.c                |  72 ++----
 13 files changed, 270 insertions(+), 203 deletions(-)
 create mode 100644 tools/cgroup/.gitignore
 create mode 100644 tools/cgroup/Makefile
 rename {Documentation/cgroups => tools/cgroup}/cgroup_event_listener.c (54%)

Thanks.

--
tejun

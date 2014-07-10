Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbaGJPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 11:25:28 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:42513 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbaGJPZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 11:25:26 -0400
Date: Thu, 10 Jul 2014 11:25:22 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        cgroups@vger.kernel.org
Subject: [GIT PULL] cgroup fixes for v3.16-rc4
Message-ID: <20140710152522.GF6609@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

Mostly fixes for the fallouts from the recent cgroup core changes.
The decoupled nature of cgroup dynamic hierarchy management
(hierarchies are created dynamically on mount but may or may not be
reused once unmounted depending on remaining usages) led to more
ugliness being added to kernfs.  Hopefully, this is the last of it.

Thanks.

The following changes since commit ebe06187bf2aec10d537ce4595e416035367d703:

  epoll: fix use-after-free in eventpoll_release_file (2014-06-16 17:21:59 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.16-fixes

for you to fetch changes up to 76bb5ab8f6e3e7bebdcefec4146ff305e7d0b465:

  cpuset: break kernfs active protection in cpuset_write_resmask() (2014-07-01 16:42:28 -0400)

----------------------------------------------------------------
Gu Zheng (1):
      cpuset,mempolicy: fix sleeping function called from invalid context

Li Zefan (4):
      cgroup: fix broken css_has_online_children()
      cgroup: fix mount failure in a corner case
      kernfs: introduce kernfs_pin_sb()
      cgroup: fix a race between cgroup_mount() and cgroup_kill_sb()

Tejun Heo (1):
      cpuset: break kernfs active protection in cpuset_write_resmask()

 fs/kernfs/mount.c      | 30 ++++++++++++++++++++++++++
 include/linux/kernfs.h |  1 +
 kernel/cgroup.c        | 58 +++++++++++++++++++++++++++++++++++++++++++-------
 kernel/cpuset.c        | 20 ++++++++++++++++-
 mm/mempolicy.c         |  2 --
 5 files changed, 100 insertions(+), 11 deletions(-)

-- 
tejun

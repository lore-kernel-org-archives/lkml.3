Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbaELSP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:15:28 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:61802 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaELSP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:15:26 -0400
Date: Mon, 12 May 2014 14:15:23 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        cgroups@vger.kernel.org
Subject: [GIT PULL] cgroup fixes for v3.15-rc5
Message-ID: <20140512181523.GG1421@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

During recent restructuring, device_cgroup unified config input check
and enforcement logic; unfortunately, it turned out to share too much.
Aristeu's patches fix the breakage and marked for -stable backport.

The other two patches are fallouts from kernfs conversion.  The blkcg
change is temporary and will go away once kernfs internal locking gets
simplified (patches pending).

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.15-fixes

for you to fetch changes up to 36c38fb7144aa941dc072ba8f58b2dbe509c0345:

  blkcg: use trylock on blkcg_pol_mutex in blkcg_reset_stats() (2014-05-05 13:48:18 -0400)

Thanks.

----------------------------------------------------------------
Aristeu Rozanski (3):
      device_cgroup: rework device access check and exception checking
      device_cgroup: fix the comment format for recently added functions
      device_cgroup: check if exception removal is allowed

Li Zefan (1):
      cgroup: fix the retry path of cgroup_mount()

Tejun Heo (1):
      blkcg: use trylock on blkcg_pol_mutex in blkcg_reset_stats()

 block/blk-cgroup.c       |  15 +++-
 kernel/cgroup.c          |   8 +-
 security/device_cgroup.c | 202 +++++++++++++++++++++++++++++++++++++----------
 3 files changed, 177 insertions(+), 48 deletions(-)

-- 
tejun

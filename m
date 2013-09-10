Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab3IJOTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 10:19:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab3IJOTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 10:19:12 -0400
Date: Tue, 10 Sep 2013 10:19:03 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        Alasdair G Kergon <agk@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>, Tejun Heo <tj@kernel.org>,
        Joe Thornber <ejt@redhat.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>, Joe Jin <joe.jin@oracle.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [git pull] device-mapper changes for 3.12
Message-ID: <20130910141902.GA24038@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit b936bf8b785f0fbe083d203049e4da1c56ec788f:

  dm cache: avoid conflicting remove_mapping() in mq policy (2013-08-16 15:56:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.12-changes

for you to fetch changes up to 7fff5e8f727285cf54e6aba10f31b196f207b98a:

  dm stripe: silence a couple sparse warnings (2013-09-06 11:36:01 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
Add the ability to collect I/O statistics on user-defined regions of a
device-mapper device.  This dm-stats code required the reintroduction of
a div64_u64_rem() helper, but as a separate method that doesn't slow
down div64_u64() -- especially on 32-bit systems.

Allow the error target to replace request-based DM devices
(e.g. multipath) in addition to bio-based DM devices.

Various other small code fixes and improvements to thin-provisioning, DM
cache and the DM ioctl interface.

----------------------------------------------------------------
Alasdair Kergon (1):
      dm ioctl: prevent rename to empty name or uuid

Carlos Maiolino (1):
      dm thin: add data block size limits to Documentation

Joe Thornber (3):
      dm btree: use pop_frame in dm_btree_del to cleanup code
      dm btree: prefetch child nodes when walking tree for a dm_btree_del
      dm space map: optimise sm_ll_dec and sm_ll_inc

Mike Snitzer (13):
      dm cache: document metadata device is exclussive to a cache
      dm cache: add data block size limits to code and Documentation
      dm thin: fix stacking of geometry limits
      dm cache: fix stacking of geometry limits
      dm cache: eliminate holes in cache structure
      math64: New separate div64_u64_rem helper
      dm: allow error target to replace bio-based and request-based targets
      dm thin: prefix pool error messages with pool device name
      dm thin: set pool read-only if breaking_sharing fails block allocation
      dm ioctl: increase granularity of type_lock when loading table
      dm ioctl: cleanup error handling in table_load
      dm thin: always return -ENOSPC if no_free_space is set
      dm stripe: silence a couple sparse warnings

Mikulas Patocka (1):
      dm: add statistics support

Tejun Heo (1):
      dm: stop using WQ_NON_REENTRANT

 Documentation/device-mapper/cache.txt             |   6 +-
 Documentation/device-mapper/statistics.txt        | 186 +++++
 Documentation/device-mapper/thin-provisioning.txt |  15 +-
 drivers/md/Makefile                               |   2 +-
 drivers/md/dm-cache-target.c                      |  59 +-
 drivers/md/dm-crypt.c                             |  10 +-
 drivers/md/dm-ioctl.c                             |  60 +-
 drivers/md/dm-kcopyd.c                            |   3 +-
 drivers/md/dm-raid1.c                             |   3 +-
 drivers/md/dm-stats.c                             | 969 ++++++++++++++++++++++
 drivers/md/dm-stats.h                             |  40 +
 drivers/md/dm-stripe.c                            |   1 +
 drivers/md/dm-table.c                             |  20 +-
 drivers/md/dm-target.c                            |   9 +-
 drivers/md/dm-thin.c                              | 122 ++-
 drivers/md/dm.c                                   |  70 +-
 drivers/md/dm.h                                   |  27 +
 drivers/md/persistent-data/dm-block-manager.c     |   5 +
 drivers/md/persistent-data/dm-block-manager.h     |   5 +
 drivers/md/persistent-data/dm-btree.c             |  28 +-
 drivers/md/persistent-data/dm-space-map-common.c  |  77 +-
 include/linux/device-mapper.h                     |   9 +
 include/linux/math64.h                            |  13 +
 include/uapi/linux/dm-ioctl.h                     |   4 +-
 lib/div64.c                                       |  40 +
 25 files changed, 1621 insertions(+), 162 deletions(-)
 create mode 100644 Documentation/device-mapper/statistics.txt
 create mode 100644 drivers/md/dm-stats.c
 create mode 100644 drivers/md/dm-stats.h

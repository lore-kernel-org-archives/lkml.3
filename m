Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaHMQHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:07:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbaHMQHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:07:42 -0400
Date: Wed, 13 Aug 2014 12:07:37 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [git pull] device mapper changes for 3.17
Message-ID: <20140813160737.GA11779@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 44fa816bb778edbab6b6ddaaf24908dd6295937e:

  dm cache: fix race affecting dirty block count (2014-08-01 12:25:22 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.17-changes

for you to fetch changes up to 200612ec33e555a356eebc717630b866ae2b694f:

  dm table: propagate QUEUE_FLAG_NO_SG_MERGE (2014-08-10 20:54:49 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
. Allow the thin target to paired with any size external origin; also
  allow thin snapshots to be larger than the external origin.

. Add support for quickly loading a repetitive pattern into the
  dm-switch target.

. Use per-bio data in the dm-crypt target instead of always using a
  mempool for each allocation.  Required switching to kmalloc alignment
  for the bio slab.

. Fix DM core to properly stack the QUEUE_FLAG_NO_SG_MERGE flag

. Fix the dm-cache and dm-thin targets' export of the minimum_io_size to
  match the data block size -- this fixes an issue where mkfs.xfs would
  improperly infer raid striping was in place on the underlying storage.

. Small cleanups in dm-io, dm-mpath and dm-cache

----------------------------------------------------------------
Jeff Moyer (1):
      dm table: propagate QUEUE_FLAG_NO_SG_MERGE

Joe Thornber (5):
      dm io: simplify dec_count and sync_io
      dm thin: switch to an atomic_t for tracking pending new block preparations
      dm thin: relax external origin size constraints
      dm cache: simplify deferred set reference count increments
      dm cache: fail migrations in the do_worker error path

Mike Snitzer (4):
      dm mpath: eliminate pg_ready() wrapper
      dm cache metadata: use dm-space-map-metadata.h defined size limits
      dm thin: set minimum_io_size to pool's data block size
      dm cache: set minimum_io_size to cache's data block size

Mikulas Patocka (5):
      dm table: make dm_table_supports_discards static
      block: use kmalloc alignment for bio slab
      dm crypt: use per-bio data
      dm switch: factor out switch_region_table_read
      dm switch: efficiently support repetitive patterns

 Documentation/device-mapper/switch.txt |  12 +++
 block/bio.c                            |   3 +-
 drivers/md/dm-cache-metadata.c         |   4 +-
 drivers/md/dm-cache-metadata.h         |   8 +-
 drivers/md/dm-cache-target.c           | 128 ++++++++++++++---------
 drivers/md/dm-crypt.c                  |  41 +++++---
 drivers/md/dm-io.c                     |  77 +++++++-------
 drivers/md/dm-mpath.c                  |   6 +-
 drivers/md/dm-switch.c                 |  67 ++++++++++--
 drivers/md/dm-table.c                  |  86 +++++++++-------
 drivers/md/dm-thin.c                   | 181 +++++++++++++++++++++++----------
 drivers/md/dm.h                        |   1 -
 12 files changed, 408 insertions(+), 206 deletions(-)

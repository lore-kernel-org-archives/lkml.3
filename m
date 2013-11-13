Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778Ab3KMCsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 21:48:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513Ab3KMCsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 21:48:02 -0500
Date: Tue, 12 Nov 2013 21:47:51 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alasdair G Kergon <agk@redhat.com>,
        Andy Speagle <Andy.Speagle@netapp.com>, Hannes Reinecke <hare@suse.de>,
        Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Junichi Nomura <j-nomura@ce.jp.nec.com>,
        Krishnasamy Somasundaram <somasundaram.krishnasamy@netapp.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Morgan Mears <Morgan.Mears@netapp.com>,
        Shiva Krishna Merla <shivakrishna.merla@netapp.com>
Subject: [git pull] device mapper changes for 3.13
Message-ID: <20131113024751.GB1540@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 61e6cfa80de5760bbe406f4e815b7739205754d2:

  Linux 3.12-rc5 (2013-10-13 15:41:28 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.13-changes

for you to fetch changes up to 7b6b2bc98c0303b7f043ad5b35906f833e56308d:

  dm cache: resolve small nits and improve Documentation (2013-11-12 13:11:09 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
A set of device-mapper changes for 3.13.

Improve reliability of buffer allocations for dm messages with a small
number of arguments, a couple path group initialization fixes for dm
multipath, a fix for resizing a dm array, various fixes and
optimizations for dm cache, a fix for device mapper's Kconfig menu
indentation.

Features added include:
- dm crypt support for activating legacy CBC TrueCrypt containers
  (useful for forensics of these old TCRYPT containers)
- reduced dm-cache memory requirements for each block in the cache
- basic support for shrinking a dm-cache's cache (fast) device
- most notably, dm-cache support for managing cache coherency when
  deploying dm-cache with sophisticated origin volumes (that support
  hardware snapshots and/or clustering): these changes come in the form
  of a new passthrough operation mode and a cache block invalidation
  interface.

----------------------------------------------------------------
Hannes Reinecke (1):
      dm mpath: requeue I/O during pg_init

Heinz Mauelshagen (3):
      dm cache: use cell_defer() boolean argument consistently
      dm cache: log error message if dm_kcopyd_copy() fails
      dm cache: optimize commit_if_needed

Joe Thornber (18):
      dm array: fix bug in growing array
      dm cache policy mq: protect residency method with existing mutex
      dm cache: io destined for the cache device can now serve as tick bios
      dm cache: fix a race condition between queuing new migrations and quiescing for a shutdown
      dm cache: improve efficiency of quiescing flag management
      dm cache policy: remove return from void policy_remove_mapping
      dm cache policy mq: a few small fixes
      dm cache metadata: return bool from __superblock_all_zeroes
      dm space map disk: optimise sm_disk_dec_block
      dm cache policy mq: implement writeback_work() and mq_{set,clear}_dirty()
      dm cache: be much more aggressive about promoting writes to discarded blocks
      dm cache: promotion optimisation for writes
      dm cache: cache shrinking support
      dm cache: add passthrough mode
      dm cache metadata: check the metadata version when reading the superblock
      dm cache policy mq: reduce memory requirements
      dm cache: add remove_cblock method to policy interface
      dm cache: add cache block invalidation support

Mike Snitzer (3):
      dm table: print error on preresume failure
      MAINTAINERS: add reference to device-mapper's linux-dm.git tree
      dm cache: resolve small nits and improve Documentation

Mikulas Patocka (4):
      dm: allocate buffer for messages with small number of arguments using GFP_NOIO
      dm cache: return -EINVAL if the user specifies unknown cache policy
      dm: allow remove to be deferred
      dm: fix Kconfig menu indentation

Milan Broz (2):
      dm crypt: properly handle extra key string in initialization
      dm crypt: add TCW IV mode for old CBC TCRYPT containers

Shiva Krishna Merla (1):
      dm mpath: fix race condition between multipath_dtr and pg_init_done

 Documentation/device-mapper/cache-policies.txt |   6 +-
 Documentation/device-mapper/cache.txt          |  57 +-
 Documentation/device-mapper/dm-crypt.txt       |  11 +-
 MAINTAINERS                                    |   1 +
 drivers/md/Kconfig                             |  22 +-
 drivers/md/dm-cache-metadata.c                 | 104 +++-
 drivers/md/dm-cache-metadata.h                 |   5 +
 drivers/md/dm-cache-policy-internal.h          |   7 +-
 drivers/md/dm-cache-policy-mq.c                | 681 ++++++++++++++----------
 drivers/md/dm-cache-policy.c                   |   4 +-
 drivers/md/dm-cache-policy.h                   |  21 +-
 drivers/md/dm-cache-target.c                   | 687 +++++++++++++++++++++----
 drivers/md/dm-crypt.c                          | 214 +++++++-
 drivers/md/dm-ioctl.c                          |  36 +-
 drivers/md/dm-mpath.c                          |  34 +-
 drivers/md/dm-table.c                          |  23 +-
 drivers/md/dm.c                                |  47 +-
 drivers/md/dm.h                                |  13 +-
 drivers/md/persistent-data/dm-array.c          |   5 +-
 drivers/md/persistent-data/dm-space-map-disk.c |  18 +-
 include/uapi/linux/dm-ioctl.h                  |  15 +-
 21 files changed, 1544 insertions(+), 467 deletions(-)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbaJQTMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 15:12:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbaJQTL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 15:11:59 -0400
Date: Fri, 17 Oct 2014 15:11:45 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Junichi Nomura <j-nomura@ce.jp.nec.com>,
        Benjamin Marzinski <bmarzins@redhat.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Heinz Mauelshagen <heinzm@redhat.com>
Subject: [git pull] device mapper changes for 3.18
Message-ID: <20141017191144.GA26800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I rebased the DM tree ontop of linux-block.git's 'for-3.18/core' at the
beginning of October because DM core now depends on the newly introduced
bioset_create_nobvec() interface.

The following changes since commit d8f429e1669b9709f5b669aac9d734dbe0640891:

  block: add bioset_create_nobvec() (2014-10-03 15:28:18 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.18

for you to fetch changes up to 56ec16cb1e1ce46354de8511eef962a417c32c92:

  dm log userspace: fix memory leak in dm_ulog_tfr_init failure path (2014-10-05 20:03:38 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
. fix DM's long-standing excessive use of memory by leveraging the new
  bioset_create_nobvec() interface when creating the DM's bioset

. fix a few bugs in dm-bufio and dm-log-userspace

. add DM core support for a DM multipath use-case that requires loading
  DM tables that contain devices that have failed (by allowing active
  and inactive DM tables to share dm_devs)

. add discard support to the DM raid target; like MD raid456 the user
  must opt-in to raid456 discard support be specifying the
  devices_handle_discard_safely=Y module param.

----------------------------------------------------------------
Alexey Khoroshilov (1):
      dm log userspace: fix memory leak in dm_ulog_tfr_init failure path

Benjamin Marzinski (2):
      dm mpath: stop queueing IO when no valid paths exist
      dm: allow active and inactive tables to share dm_devs

Heinz Mauelshagen (2):
      dm raid: add discard support for RAID levels 1 and 10
      dm raid: add discard support for RAID levels 4, 5 and 6

Joe Thornber (1):
      dm bufio: update last_accessed when relinking a buffer

Junichi Nomura (2):
      dm: remove nr_iovecs parameter from alloc_tio()
      dm: use bioset_create_nobvec()

Mikulas Patocka (1):
      dm bufio: when done scanning return from __scan immediately

 drivers/md/dm-bufio.c                  |   5 +-
 drivers/md/dm-ioctl.c                  |   2 +-
 drivers/md/dm-log-userspace-transfer.c |   2 +-
 drivers/md/dm-mpath.c                  |   4 +-
 drivers/md/dm-raid.c                   |  60 +++++++++++++-
 drivers/md/dm-table.c                  | 102 ++++++++---------------
 drivers/md/dm.c                        | 143 ++++++++++++++++++++++++++++++---
 drivers/md/dm.h                        |   5 +-
 include/uapi/linux/dm-ioctl.h          |   4 +-
 9 files changed, 238 insertions(+), 89 deletions(-)

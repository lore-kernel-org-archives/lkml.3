Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387AbaFLONq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 10:13:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933235AbaFLONl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 10:13:41 -0400
Date: Thu, 12 Jun 2014 10:13:37 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>
Subject: [git pull] device mapper changes for 3.16
Message-ID: <20140612141337.GB27768@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This pull request is later than I'd have liked because I was waiting for
some performance data to help finally justify sending the long-standing
dm-crypt cpu scalability improvements upstream.  Unfortunately we came
up short, so those dm-crypt changes will continue to wait, but it seems
we're not far off.

The following changes since commit fad01e866afdbe01a1f3ec06a39c3a8b9e197014:

  Linux 3.15-rc8 (2014-06-01 19:12:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.16-changes

for you to fetch changes up to 09869de57ed2728ae3c619803932a86cb0e2c4f8:

  dm thin: update discard_granularity to reflect the thin-pool blocksize (2014-06-11 16:56:12 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
. Add dm_accept_partial_bio interface to DM core to allow DM targets
  to only process a portion of a bio, the remainder being sent in the
  next bio.  This enables the old dm snapshot-origin target to only
  split write bios on chunk boundaries, read bios are now sent to the
  origin device unchanged.

. Add DM core support for disabling WRITE SAME if the underlying SCSI
  layer disables it due to command failure.

. Reduce lock contention in DM's bio-prison.

. A few small cleanups and fixes to dm-thin and dm-era.

----------------------------------------------------------------
Heinz Mauelshagen (1):
      dm bio prison: implement per bucket locking in the dm_bio_prison hash table

Joe Thornber (2):
      dm thin: cleanup noflush_work to use a proper completion
      dm era: check for a non-NULL metadata object before closing it

Lukas Czerner (1):
      dm thin: update discard_granularity to reflect the thin-pool blocksize

Mike Snitzer (3):
      dm thin: return ENOSPC instead of EIO when error_if_no_space enabled
      dm: disable WRITE SAME if it fails
      dm: remove symbol export for dm_set_device_limits

Mikulas Patocka (4):
      dm: change sector_count member in clone_info from sector_t to unsigned
      dm: introduce dm_accept_partial_bio
      dm snapshot: allocate a per-target structure for snapshot-origin target
      dm snapshot: do not split read bios sent to snapshot-origin target

 drivers/md/dm-bio-prison.c    | 70 ++++++++++++++++++--------------
 drivers/md/dm-bio-prison.h    |  2 +-
 drivers/md/dm-era-target.c    |  3 +-
 drivers/md/dm-mpath.c         | 11 +----
 drivers/md/dm-snap.c          | 67 ++++++++++++++++++++++---------
 drivers/md/dm-table.c         |  5 +--
 drivers/md/dm-thin.c          | 93 ++++++++++++++++++++++++++++---------------
 drivers/md/dm.c               | 86 ++++++++++++++++++++++++++++++++-------
 include/linux/device-mapper.h | 10 ++---
 9 files changed, 230 insertions(+), 117 deletions(-)

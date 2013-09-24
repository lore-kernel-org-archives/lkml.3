Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab3IXANb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 20:13:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab3IXANa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 20:13:30 -0400
Date: Mon, 23 Sep 2013 20:13:20 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>,
        Frank Mayhar <fmayhar@google.com>, Hannes Reinecke <hare@suse.de>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: [git pull] device mapper fixes for 3.12
Message-ID: <20130924001320.GA27767@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.12-fixes

for you to fetch changes up to e8603136cb04ec2d0c9b4b5be7a071fc003cb399:

  dm: add reserved_bio_based_ios module parameter (2013-09-23 10:42:24 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
A set of device-mapper fixes for 3.12.

A few fixes for dm-snapshot, a 32 bit fix for dm-stats, a couple error
handling fixes for dm-multipath.  A fix for the thin provisioning target
to not expose non-zero discard limits if discards are disabled.

Lastly, add two DM module parameters which allow users to tune the
emergency memory reserves that DM mainatins per device -- this helps fix
a long-standing issue for dm-multipath.  The conservative default
reserve for request-based dm-multipath devices (256) has proven
problematic for users with many multipathed SCSI devices but relatively
little memory.  To responsibly select a smaller value users should use
the new nr_bios tracepoint info (via commit 75afb352 "block: Add nr_bios
to block_rq_remap tracepoint") to determine the peak number of bios
their workloads create.

----------------------------------------------------------------
Jun'ichi Nomura (1):
      dm mpath: do not fail path on -ENOSPC

Mike Snitzer (5):
      dm mpath: disable WRITE SAME if it fails
      dm thin: do not expose non-zero discard limits if discards disabled
      dm: lower bio-based mempool reservation
      dm: add reserved_rq_based_ios module parameter
      dm: add reserved_bio_based_ios module parameter

Mikulas Patocka (3):
      dm stats: fix possible counter corruption on 32-bit systems
      dm snapshot: workaround for a false positive lockdep warning
      dm-snapshot: fix performance degradation due to small hash size

 drivers/md/dm-io.c              |  7 ++--
 drivers/md/dm-mpath.c           | 18 ++++++++---
 drivers/md/dm-snap-persistent.c |  2 +-
 drivers/md/dm-snap.c            |  5 ++-
 drivers/md/dm-stats.c           | 23 +++++++++----
 drivers/md/dm-thin.c            | 14 ++++++--
 drivers/md/dm.c                 | 71 ++++++++++++++++++++++++++++++++++++++---
 drivers/md/dm.h                 |  3 ++
 include/linux/device-mapper.h   |  3 +-
 9 files changed, 120 insertions(+), 26 deletions(-)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaB1SDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 13:03:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbaB1SDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 13:03:41 -0500
Date: Fri, 28 Feb 2014 13:03:37 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>, Hannes Reinecke <hare@suse.de>,
        "Alasdair G. Kergon" <agk@redhat.com>
Subject: [git pull] device mapper fixes to include in 3.14-rc5
Message-ID: <20140228180335.GA27146@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.14-fixes-1

for you to fetch changes up to e0d849fad746cb36a6822e4595d8ba9bf0adf7fa:

  dm cache: fix truncation bug when mapping I/O to >2TB fast device (2014-02-28 09:23:02 -0500)

There will likely be additional dm-thin metadata and data resize fixes
to include in 3.14-rc6 next week.  But please pull for the following
fixes.

Thanks,
Mike

p.s.
Note to stable-minded folks: Immutable biovecs were introduced in 3.14,
so the related fixups for dm mirror are not needed in stable@ kernels.

----------------------------------------------------------------
A few dm-cache fixes, an invalid ioctl handling fix for dm multipath, a
couple immutable biovec fixups for dm mirror, and a few dm-thin fixes.

----------------------------------------------------------------
Hannes Reinecke (1):
      dm mpath: fix stalls when handling invalid ioctls

Heinz Mauelshagen (1):
      dm cache: fix truncation bug when mapping I/O to >2TB fast device

Mike Snitzer (5):
      dm cache: move hook_info into common portion of per_bio_data structure
      dm cache: do not add migration to completed list before unhooking bio
      dm thin: avoid metadata commit if a pool's thin devices haven't changed
      dm thin: fix the error path for the thin device constructor
      dm thin: allow metadata space larger than supported to go unused

Mikulas Patocka (2):
      dm io: fix I/O to multiple destinations
      dm raid1: fix immutable biovec related BUG when retrying read bio

 drivers/md/dm-cache-target.c                       | 13 +++++---
 drivers/md/dm-io.c                                 | 23 ++++++-------
 drivers/md/dm-mpath.c                              |  7 ++--
 drivers/md/dm-raid1.c                              |  3 ++
 drivers/md/dm-thin-metadata.c                      | 21 ++++++++++--
 drivers/md/dm-thin-metadata.h                      | 10 +++---
 drivers/md/dm-thin.c                               | 39 ++++++++++++++--------
 drivers/md/persistent-data/dm-space-map-metadata.c |  2 ++
 drivers/md/persistent-data/dm-space-map-metadata.h | 11 ++++++
 9 files changed, 89 insertions(+), 40 deletions(-)

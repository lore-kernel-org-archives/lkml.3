Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbaKMAed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 19:34:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbaKMAea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 19:34:30 -0500
Date: Wed, 12 Nov 2014 19:34:26 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Pavitra Kumar <pavitrak@nvidia.com>
Subject: [git pull] device mapper fixes for 3.18
Message-ID: <20141113003425.GA9508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 56ec16cb1e1ce46354de8511eef962a417c32c92:

  dm log userspace: fix memory leak in dm_ulog_tfr_init failure path (2014-10-05 20:03:38 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.18-fixes

for you to fetch changes up to 9b460d3699324d570a4d4161c3741431887f102f:

  dm btree: fix a recursion depth bug in btree walking code (2014-11-10 15:23:58 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
. stable fix for dm-thin that avoids normal IO racing with discard

. stable fix for a dm-cache related bug in dm-btree walking code that
  results from using very large fast device (e.g. 4T) with a very small
  cache blocksize (e.g. 32K) -- this is a very uncommon configuration

. a couple fixes for dm-raid (one for stable and the other addresses a
  crash in 3.18-rc1 code)

. stable fix for dm-thinp that addresses a very rare dm-bufio bug having
  to do with memory reclaimation (via shrinker) when using dm-thinp
  ontop of loopback devices

. fix a leak in dm-stripe target constructor's error path

----------------------------------------------------------------
Heinz Mauelshagen (2):
      dm raid: ensure superblock's size matches device's logical block size
      dm raid: fix inaccessible superblocks causing oops in configure_discard_support

Joe Thornber (2):
      dm thin: grab a virtual cell before looking up the mapping
      dm btree: fix a recursion depth bug in btree walking code

Mikulas Patocka (1):
      dm bufio: change __GFP_IO to __GFP_FS in shrinker callbacks

Pavitra Kumar (1):
      dm stripe: fix potential for leak in stripe_ctr error path

 drivers/md/dm-bufio.c                          | 12 ++++++------
 drivers/md/dm-raid.c                           | 17 ++++++++++++-----
 drivers/md/dm-stripe.c                         |  4 +++-
 drivers/md/dm-thin.c                           | 16 ++++++++++++----
 drivers/md/persistent-data/dm-btree-internal.h |  6 ++++++
 drivers/md/persistent-data/dm-btree-spine.c    |  2 +-
 drivers/md/persistent-data/dm-btree.c          | 24 ++++++++++--------------
 7 files changed, 50 insertions(+), 31 deletions(-)

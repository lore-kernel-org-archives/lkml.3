Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaCFUuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:50:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbaCFUuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:50:54 -0500
Date: Thu, 6 Mar 2014 15:50:51 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "Alasdair G. Kergon" <agk@redhat.com>
Subject: [git pull] device mapper fixes to include in 3.14-rc6
Message-ID: <20140306205051.GA24631@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit e0d849fad746cb36a6822e4595d8ba9bf0adf7fa:

  dm cache: fix truncation bug when mapping I/O to >2TB fast device (2014-02-28 09:23:02 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.14-fixes-2

for you to fetch changes up to f6d16d32797f665100b1507f6a77c4cd0acb30c5:

  dm thin: fix Documentation for held metadata root feature (2014-03-06 14:23:35 -0500)

Please pull.

Thanks,
Mike

----------------------------------------------------------------
A dm-cache memory allocation failure fix, fix DM's Kconfig identation, a
dm-snapshot metadata corruption fix for bug introduced in 3.14-rc1, and
last but not least: more extensive fixes than ideal for dm-thinp's data
resize capability (which has had growing pain much like we've seen from
-ENOSPC handling of filesystems that mature).  The end result is dm-thinp
now handles metadata operation failure and no data space error
conditions much better than before.

----------------------------------------------------------------
Heinz Mauelshagen (1):
      dm cache mq: fix memory allocation failure for large cache devices

Joe Thornber (3):
      dm thin: fix out of data space handling
      dm thin: fix deadlock in __requeue_bio_list
      dm thin: fix noflush suspend IO queueing

Mike Snitzer (4):
      dm: fix Kconfig indentation
      dm thin: synchronize the pool mode during suspend
      dm thin: ensure user takes action to validate data and metadata consistency
      dm thin: fix Documentation for held metadata root feature

Mikulas Patocka (1):
      dm snapshot: fix metadata corruption

 Documentation/device-mapper/cache.txt             |  11 +-
 Documentation/device-mapper/thin-provisioning.txt |  34 ++-
 drivers/md/Kconfig                                |  10 -
 drivers/md/dm-cache-policy-mq.c                   |   4 +-
 drivers/md/dm-snap-persistent.c                   |   3 +
 drivers/md/dm-thin-metadata.c                     |  37 ++-
 drivers/md/dm-thin-metadata.h                     |  11 +
 drivers/md/dm-thin.c                              | 304 +++++++++++++++++-----
 drivers/md/persistent-data/Kconfig                |  10 +
 9 files changed, 333 insertions(+), 91 deletions(-)

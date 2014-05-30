Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaE3A5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 20:57:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbaE3A5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 20:57:19 -0400
Date: Thu, 29 May 2014 20:57:15 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, Hannes Reinecke <hare@suse.de>
Subject: [git pull] device mapper fixes for 3.15 final
Message-ID: <20140530005715.GA9179@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 4cdd2ad78098244c1bc9ec4374ea1c225fd1cd6f:

  dm mpath: fix lock order inconsistency in multipath_ioctl (2014-05-14 16:12:17 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.15-fixes-3

for you to fetch changes up to 63d832c30142cdceb478b1cac7d943d83b95b2dc:

  dm mpath: really fix lockdep warning (2014-05-27 10:46:01 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
A dm-cache stable fix to split discards on cache block boundaries
because dm-cache cannot yet handle discards that span cache blocks.

Really fix a dm-mpath LOCKDEP warning that was introduced in -rc1.

Add a 'no_space_timeout' control to dm-thinp to restore the ability to
queue IO indefinitely when no data space is available.  This fixes a
change in behavior that was introduced in -rc6 where the timeout
couldn't be disabled.

----------------------------------------------------------------
Hannes Reinecke (1):
      dm mpath: really fix lockdep warning

Heinz Mauelshagen (1):
      dm cache: always split discards on cache block boundaries

Mike Snitzer (1):
      dm thin: add 'no_space_timeout' dm-thin-pool module param

 Documentation/device-mapper/thin-provisioning.txt |  5 ++++-
 drivers/md/dm-cache-target.c                      |  2 ++
 drivers/md/dm-mpath.c                             | 14 ++++++++------
 drivers/md/dm-thin.c                              | 12 +++++++++---
 4 files changed, 23 insertions(+), 10 deletions(-)

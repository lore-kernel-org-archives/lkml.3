Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbaLVSlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 13:41:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbaLVSlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 13:41:12 -0500
Date: Mon, 22 Dec 2014 13:41:04 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>,
        zhendong chen <alex.chen@huawei.com>,
        Marc Dionne <marc.c.dionne@gmail.com>
Subject: [git pull] device mapper fixes for 3.19
Message-ID: <20141222184104.GA8054@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 9b8ec916df67ba31614796037caf606b763e2e79:

  Merge branch 'for-linus' of git://git.kernel.dk/linux-block (2014-12-15 17:25:20 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.19-fixes

for you to fetch changes up to 5164bece1673cdf04782f8ed3fba70743700f5da:

  dm: fix missed error code if .end_io isn't implemented by target_type (2014-12-17 12:31:13 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
3 stable fixes and 1 fix for a regression introduced during 3.19 merge:

- Fix inability to discard used space when the thin-pool target is in
  out-of-data-space mode and also transition the thin-pool back to write
  mode once free space is made available.

- Fix DM core bio-based end_io bug that prevented proper post-processing
  of the error code returned from the block layer.

- Fix crash in DM thin-pool due to thin device being added to the pool's
  active_thins list before properly initializing the thin device's
  refcount.

----------------------------------------------------------------
Joe Thornber (2):
      dm thin: fix inability to discard blocks when in out-of-data-space mode
      dm thin: fix missing out-of-data-space to write mode transition if blocks are released

Marc Dionne (1):
      dm thin: fix crash by initializing thin device's refcount and completion earlier

zhendong chen (1):
      dm: fix missed error code if .end_io isn't implemented by target_type

 drivers/md/dm-thin.c | 29 +++++++++++++++++++++++------
 drivers/md/dm.c      |  2 +-
 2 files changed, 24 insertions(+), 7 deletions(-)

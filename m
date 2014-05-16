Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbaEPOvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:51:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756343AbaEPOvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:51:17 -0400
Date: Fri, 16 May 2014 10:51:15 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: [git pull] device mapper fixes for 3.15-rc6
Message-ID: <20140516145115.GA29451@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d6d211db37e75de2ddc3a4f979038c40df7cc79c:

  Linux 3.15-rc5 (2014-05-09 13:10:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.15-fixes-2

for you to fetch changes up to 4cdd2ad78098244c1bc9ec4374ea1c225fd1cd6f:

  dm mpath: fix lock order inconsistency in multipath_ioctl (2014-05-14 16:12:17 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
A dm-crypt fix for a cpu hotplug crash that switches from using per-cpu
data to a mempool allocation (which offers allocation with cpu locality,
and there is no inter-cpu communication on slab allocation).

A couple dm-thinp stable fixes to address "out-of-data-space" issues.

A dm-multipath fix for a LOCKDEP warning introduced in 3.15-rc1.

----------------------------------------------------------------
Joe Thornber (2):
      dm thin: allow metadata commit if pool is in PM_OUT_OF_DATA_SPACE mode
      dm thin: add timeout to stop out-of-data-space mode holding IO forever

Mike Snitzer (1):
      dm mpath: fix lock order inconsistency in multipath_ioctl

Mikulas Patocka (1):
      dm crypt: fix cpu hotplug crash by removing per-cpu structure

 drivers/md/dm-crypt.c | 61 ++++++++++-----------------------------------------
 drivers/md/dm-mpath.c |  2 +-
 drivers/md/dm-thin.c  | 23 ++++++++++++++++++-
 3 files changed, 35 insertions(+), 51 deletions(-)

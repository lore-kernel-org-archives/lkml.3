Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaEBTYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 15:24:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbaEBTYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 15:24:21 -0400
Date: Fri, 2 May 2014 15:24:18 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [git pull] device mapper fixes for 3.15-rc4
Message-ID: <20140502192417.GA23866@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0596661f0a16d9d69bf1033320e70b6ff52b5e81:

  dm cache: fix a lock-inversion (2014-04-04 14:53:05 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.15-fixes

for you to fetch changes up to 131cd131a9ff63d4b84f3fe15073a2984ac30066:

  dm cache: fix writethrough mode quiescing in cache_map (2014-05-01 16:14:24 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
A few dm-thinp fixes for changes merged in 3.15-rc1.

A dm-verity fix for an immutable biovec regression that affects 3.14+.

A dm-cache fix to properly quiesce when using writethrough mode (3.14+).

----------------------------------------------------------------
Joe Thornber (2):
      dm thin: irqsave must always be used with the pool->lock spinlock
      dm thin: fix rcu_read_lock being held in code that can sleep

Mike Snitzer (2):
      dm thin: use INIT_WORK_ONSTACK in noflush_work to avoid ODEBUG warning
      dm cache: fix writethrough mode quiescing in cache_map

Milan Broz (1):
      dm verity: fix biovecs hash calculation regression

 drivers/md/dm-cache-target.c |  1 +
 drivers/md/dm-thin.c         | 77 ++++++++++++++++++++++++++++++++++++++++----
 drivers/md/dm-verity.c       | 15 +++++----
 3 files changed, 81 insertions(+), 12 deletions(-)

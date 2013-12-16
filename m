Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab3LPWYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 17:24:14 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:50448 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab3LPWYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 17:24:12 -0500
Date: Mon, 16 Dec 2013 14:24:09 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: [GIT PULL] bcache fixes for 3.13
Message-ID: <20131216222409.GD4054@kmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens - small pile of bcache fixes. I've been slacking on the writeback fixes but
those definitely need to get into 3.13:

The following changes since commit c86949486d41d9e7d7681fc72923555114fd702f:

  bcache: defensively handle format strings (2013-11-10 21:56:43 -0800)

are available in the git repository at:

  git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.13

for you to fetch changes up to 16749c23c00c686ed168471963e3ddb0f3fcd855:

  bcache: New writeback PD controller (2013-12-16 14:22:59 -0800)

----------------------------------------------------------------
Kent Overstreet (4):
      bcache: Use uninterruptible sleep in writeback
      bcache: Fix dirty_data accounting
      bcache: bugfix for race between moving_gc and bucket_invalidate
      bcache: New writeback PD controller

Nicholas Swenson (5):
      bcache: Fix for can_attach_cache()
      bcache: Fix heap_peek() macro
      bcache: fix for gc crashing when no sectors are used
      bcache: bugfix - moving_gc now moves only correct buckets
      bcache: fix for gc and writeback race

Stefan Priebe (1):
      bcache: kthread don't set writeback task to INTERUPTIBLE

Wei Yongjun (1):
      bcache: fix sparse non static symbol warning

 drivers/md/bcache/alloc.c     |  2 ++
 drivers/md/bcache/bcache.h    | 12 +++++-----
 drivers/md/bcache/btree.c     | 27 ++++++++++++++++++++--
 drivers/md/bcache/movinggc.c  | 21 ++++++++++++-----
 drivers/md/bcache/super.c     |  2 +-
 drivers/md/bcache/sysfs.c     | 50 +++++++++++++++++++++++-----------------
 drivers/md/bcache/util.c      |  8 ++++++-
 drivers/md/bcache/util.h      |  2 +-
 drivers/md/bcache/writeback.c | 53 ++++++++++++++++++++-----------------------
 9 files changed, 111 insertions(+), 66 deletions(-)

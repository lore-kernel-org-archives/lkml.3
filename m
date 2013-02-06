Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab3BFOnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 09:43:31 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59151
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750842Ab3BFOna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 09:43:30 -0500
Date: Wed, 6 Feb 2013 15:42:29 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Block bits for 3.8 final
Message-ID: <20130206144228.GU15092@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I've got a few bits pending for 3.8 final, that I better get sent out.
It's all been sitting for a while, I consider it safe.

It contains:

- Two bug fixes for mtip32xx, fixing a driver hang and a crash.

- A few-liner protocol error fix for drbd.

- A few fixes for the xen block front/back driver, fixing a potential
  data corruption issue.

- A race fix for disk_clear_events(), causing spurious warnings. Out of
  the Chrome OS base.

- A deadlock fix for disk_clear_events(), moving it to the a unfreezable
  workqueue. Also from the Chrome OS base.

Please pull!

  git://git.kernel.dk/linux-block.git for-linus


Asai Thambi S P (2):
      mtip32xx: fix for driver hang after a command timeout
      mtip32xx: fix for crash when the device surprise removed during rebuild

Derek Basehore (2):
      block: remove deadlock in disk_clear_events
      block: prevent race/cleanup

Jens Axboe (2):
      Merge branch 'stable/for-jens-3.8' of git://git.kernel.org/.../konrad/xen into for-linus
      Merge branch 'for-jens' of git://git.drbd.org/linux-drbd into for-linus

Lars Ellenberg (1):
      drbd: fix potential protocol error and resulting disconnect/reconnect

Roger Pau Monne (3):
      xen-blkback: implement safe iterator for the list of persistent grants
      llist/xen-blkfront: implement safe version of llist_for_each_entry
      xen-blkfront: handle bvecs with partial data

 block/genhd.c                       | 42 ++++++++++++++++++++++++++++---------
 drivers/block/drbd/drbd_req.c       |  2 +-
 drivers/block/drbd/drbd_req.h       |  1 +
 drivers/block/drbd/drbd_state.c     |  7 +++++++
 drivers/block/mtip32xx/mtip32xx.c   | 24 +++++++++++++++------
 drivers/block/xen-blkback/blkback.c | 18 +++++++++-------
 drivers/block/xen-blkfront.c        | 10 +++++----
 include/linux/llist.h               | 25 ++++++++++++++++++++++
 8 files changed, 101 insertions(+), 28 deletions(-)

-- 
Jens Axboe


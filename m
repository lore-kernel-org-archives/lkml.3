Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab3GAWKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:10:08 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54382 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab3GAWKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:10:05 -0400
Date: Mon, 1 Jul 2013 15:10:00 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: [GIT PULL] Bcache changes for 3.11
Message-ID: <20130701221000.GA4794@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens, here's the bcache changes for 3.11.

The following changes since commit 9e895ace5d82df8929b16f58e9f515f6d54ab82d:

  Linux 3.10-rc7 (2013-06-22 09:47:31 -1000)

are available in the git repository at:

  git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.11

for you to fetch changes up to 8e51e414a3c6d92ef2cc41720c67342a8e2c0bf7:

  bcache: Use standard utility code (2013-07-01 14:43:53 -0700)

----------------------------------------------------------------
Gabriel de Perthuis (4):
      bcache: Warn when a device is already registered.
      bcache: Send a uevent with a cached device's UUID
      bcache: Send label uevents
      bcache: Refresh usage docs

Kent Overstreet (14):
      bcache: fix a spurious gcc complaint, use scnprintf
      bcache: Convert allocator thread to kthread
      bcache: Refactor btree io
      bcache: Fix/revamp tracepoints
      bcache: Rip out pkey()/pbtree()
      bcache: Improve lazy sorting
      bcache: Initialize sectors_dirty when attaching
      bcache: Track dirty data by stripe
      bcache: Write out full stripes
      bcache: FUA fixes
      bcache: Document shrinker reserve better
      bcache: Delete fuzz tester
      bcache: Update email address
      bcache: Use standard utility code

Kumar Amit Mehta (1):
      md: bcache: io.c: fix a potential NULL pointer dereference

Masanari Iida (1):
      doc: Fix typo in documentation/bcache.txt

 Documentation/bcache.txt      |  47 +++--
 MAINTAINERS                   |   2 +-
 drivers/md/bcache/alloc.c     |  44 +++--
 drivers/md/bcache/bcache.h    |  56 ++----
 drivers/md/bcache/bset.c      |  56 ++++--
 drivers/md/bcache/bset.h      |   4 +
 drivers/md/bcache/btree.c     | 447 ++++++++++++++++++++----------------------
 drivers/md/bcache/btree.h     |  35 ++--
 drivers/md/bcache/debug.c     | 178 ++---------------
 drivers/md/bcache/debug.h     |  11 +-
 drivers/md/bcache/io.c        |  68 +++----
 drivers/md/bcache/journal.c   |  18 +-
 drivers/md/bcache/movinggc.c  |  24 +--
 drivers/md/bcache/request.c   | 189 +++++++-----------
 drivers/md/bcache/request.h   |   2 +-
 drivers/md/bcache/super.c     | 131 ++++++++++---
 drivers/md/bcache/sysfs.c     |  66 ++++---
 drivers/md/bcache/trace.c     |  47 ++++-
 drivers/md/bcache/util.c      |  17 --
 drivers/md/bcache/util.h      |   6 -
 drivers/md/bcache/writeback.c | 133 +++++++++++--
 drivers/md/bcache/writeback.h |  64 ++++++
 include/trace/events/bcache.h | 381 +++++++++++++++++++++++++----------
 23 files changed, 1119 insertions(+), 907 deletions(-)
 create mode 100644 drivers/md/bcache/writeback.h

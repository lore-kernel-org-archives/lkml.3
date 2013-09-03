Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877Ab3ICUsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 16:48:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61793 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760726Ab3ICUsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 16:48:06 -0400
Date: Tue, 3 Sep 2013 13:48:09 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: [GIT PULL] Bcache fixes
Message-ID: <20130903204809.GC11778@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens, here's the latest bcache fixes.

The last one of these fixes a (really difficult to trigger) data
corruption bug - I was waiting until the user who was able to reproduce
it had tested it to send this pull out, that's the most serious fix in
this pull.

The following changes since commit 79826c35eb99cd3c0873b8396f45fa26c87fb0b0:

  bcache: Allocation kthread fixes (2013-07-12 00:22:49 -0700)

are available in the git repository at:

  git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.11

for you to fetch changes up to bef0ef06a9fe34b08177b67d3213dceab29d3abe:

  bcache: Fix for handling overlapping extents when reading in a btree node (2013-09-03 13:42:35 -0700)

----------------------------------------------------------------
Gabriel de Perthuis (1):
      bcache: Strip endline when writing the label through sysfs

Geert Uytterhoeven (1):
      bcache: Correct printf()-style format length modifier

Kent Overstreet (7):
      bcache: Fix a dumb journal discard bug
      bcache: Fix for when no journal entries are found
      bcache: Fix a writeback performance regression
      bcache: Fix a flush/fua performance bug
      bcache: Fix a dumb CPU spinning bug in writeback
      bcache: Fix a shrinker deadlock
      bcache: Fix for handling overlapping extents when reading in a btree node

 drivers/md/bcache/bcache.h    |  7 +++----
 drivers/md/bcache/bset.c      | 39 ++++++++++++++++++++++++++++-----------
 drivers/md/bcache/btree.c     |  4 ++--
 drivers/md/bcache/journal.c   | 33 ++++++++++++++++++++-------------
 drivers/md/bcache/sysfs.c     |  9 +++++++--
 drivers/md/bcache/util.c      | 11 ++++++++++-
 drivers/md/bcache/util.h      | 12 +++++++++---
 drivers/md/bcache/writeback.c | 42 ++++++++++++++++++++----------------------
 8 files changed, 99 insertions(+), 58 deletions(-)

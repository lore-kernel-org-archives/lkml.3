Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933650Ab3D3TwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 15:52:20 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:42695 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933606Ab3D3TwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 15:52:18 -0400
Date: Tue, 30 Apr 2013 12:52:14 -0700
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk
Cc: akpm@linux-foundation.org, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Bcache fixes for 3.10
Message-ID: <20130430195214.GH9931@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jens, this is everything I've got ready for 3.10 - there's _still_
one more bug I'm trying to track down.

Andrew - I've got patches that rip out the pkey() and pbtree() macros,
but they're somewhat tied up with some other nontrivial refactorings so
I think I'm going to wait a bit on those.

The following changes since commit cef5279735d3f6f0243e626963e6d5c84efade0a:

  bcache: Disable broken btree fuzz tester (2013-04-08 13:33:49 -0700)

are available in the git repository at:

  http://evilpiepirate.org/git/linux-bcache.git bcache-for-upstream

for you to fetch changes up to cd66f1f69ed40270bb34e20b25a8111bc72a1b2a:

  bcache: Use bd_link_disk_holder() (2013-04-24 13:15:17 -0700)

----------------------------------------------------------------
Kent Overstreet (8):
      bcache: Take data offset from the bdev superblock.
      bcache: Set ra_pages based on backing device's ra_pages
      bcache: Hack around stuff that clones up to bi_max_vecs
      bcache: Correctly check against BIO_MAX_PAGES
      bcache: Fix merge_bvec_fn usage for when it modifies the bvm
      bcache: Make sure blocksize isn't smaller than device blocksize
      bcache: Allocator cleanup/fixes
      bcache: Use bd_link_disk_holder()

 drivers/md/bcache/alloc.c   |  74 +++++++++++++-------
 drivers/md/bcache/bcache.h  |  48 ++++++++++---
 drivers/md/bcache/btree.c   |   8 +--
 drivers/md/bcache/io.c      |  35 ++++++----
 drivers/md/bcache/request.c |   2 +-
 drivers/md/bcache/super.c   | 166 +++++++++++++++++++++++++++-----------------
 6 files changed, 215 insertions(+), 118 deletions(-)

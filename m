Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbaA1Q17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 11:27:59 -0500
Received: from imap.thunk.org ([74.207.234.97]:52232 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292AbaA1Q16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 11:27:58 -0500
Date: Tue, 28 Jan 2014 11:27:54 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: [GIT PULL] Ext4 changes for 3.14
Message-ID: <20140128162754.GA17770@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d0abafac8c9162f39c4f6b2f8141b772a09b3770:

  ext4: fix bigalloc regression (2014-01-06 14:00:23 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to d7092ae2973f20a39fee786c47e5edf18ced088f:

  ext4: delete "set but not used" variables (2014-01-11 13:26:56 -0500)

----------------------------------------------------------------
Bug fixes and cleanups for ext4.  We also enable the punch hole
functionality for bigalloc file systems.

----------------------------------------------------------------
David Howells (1):
      ext4: use %pd printk specificer

Jan Kara (2):
      ext4: retry allocation when inline->extent conversion failed
      ext4: standardize error handling in ext4_da_write_inline_data_begin()

Theodore Ts'o (2):
      ext4: avoid clearing beyond i_blocks when truncating an inline data file
      ext4: don't pass freed handle to ext4_walk_page_buffers

Yongqiang Yang (2):
      ext4: fix a typo in extents.c
      ext4: ext4_inode_is_fast_symlink should use EXT4_CLUSTER_SIZE

Zheng Liu (1):
      ext4: enable punch hole for bigalloc

jon ernst (1):
      ext4: delete "set but not used" variables

 fs/ext4/extents.c |  2 +-
 fs/ext4/inline.c  | 26 +++++++++++++++-----------
 fs/ext4/inode.c   | 11 +++--------
 fs/ext4/ioctl.c   |  6 +-----
 fs/ext4/namei.c   |  5 ++---
 5 files changed, 22 insertions(+), 28 deletions(-)

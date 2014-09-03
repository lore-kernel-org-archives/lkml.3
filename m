Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbaICEeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 00:34:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:37277 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbaICEeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 00:34:02 -0400
Date: Tue, 2 Sep 2014 21:34:00 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Dev Mailing List <linux-fsdevel@vger.kernel.org>,
        Linux F2FS Dev Mailing List 
	<linux-f2fs-devel@lists.sourceforge.net>
Subject: [GIT PULL] f2fs bug fixes for v3.17-rc4
Message-ID: <20140903043400.GA72553@jaegeuk-mac02.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a pull request on the f2fs bug fixes for v3.17-rc4.
Most of things are related to recovery and error handling routines.
Please pull these patches.

Thank you very much,

The following changes since commit 63d871cb0b9e4207044ced0322aa34d859fa463d:

  Merge tag 'md/3.17-fixes' of git://neil.brown.name/md (2014-08-19 09:47:01 -0500)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git tags/for-f2fs-3.17-rc4

for you to fetch changes up to b73e52824c8920a5ff754e3c8ff68466a7dd61f9:

  f2fs: reposition unlock_new_inode to prevent accessing invalid inode (2014-09-02 00:22:24 -0700)

----------------------------------------------------------------
f2fs bug fixes for 3.17-rc4

This series includes patches to:
 o fix recovery routines
 o fix bugs related to inline_data/xattr
 o fix when casting the dentry names
 o handle EIO or ENOMEM correctly
 o fix memory leak
 o fix lock coverage

----------------------------------------------------------------
Chao Yu (4):
      f2fs: fix incorrect calculation with total/free inode num
      f2fs: introduce need_do_checkpoint for readability
      f2fs: use macro for code readability
      f2fs: reposition unlock_new_inode to prevent accessing invalid inode

Dan Carpenter (1):
      f2fs: simplify by using a literal

Jaegeuk Kim (22):
      f2fs: should convert inline_data during the mkwrite
      f2fs: make clear on test condition and return types
      f2fs: fix the initial inode page for recovery
      f2fs: clear FI_INC_LINK during the recovery
      f2fs: should clear the inline_xattr flag
      f2fs: fix to recover inline_xattr/data and blocks
      f2fs: avoid bug_on when error is occurred
      f2fs: don't skip checkpoint if there is no dirty node pages
      f2fs: trigger release_dirty_inode in f2fs_put_super
      f2fs: give a chance to mount again when encountering errors
      f2fs: introduce f2fs_cp_error for readability
      f2fs: unlock_page when node page is redirtied out
      f2fs: check s_dirty under cp_mutex
      f2fs: handle EIO not to break fs consistency
      f2fs: add WARN_ON in f2fs_bug_on
      f2fs: prevent checkpoint during roll-forward
      f2fs: avoid double lock in truncate_blocks
      f2fs: remove rewrite_node_page
      f2fs: skip if inline_data was converted already
      f2fs: remove rename and use rename2
      f2fs: truncate stale block for inline_data
      f2fs: fix wrong casting for dentry name

arter97 (1):
      f2fs: fix typo

 fs/f2fs/Kconfig         |  4 +--
 fs/f2fs/checkpoint.c    | 80 +++++++++++++++++++++++++++++++------------------
 fs/f2fs/data.c          | 19 ++++++++----
 fs/f2fs/debug.c         |  4 +--
 fs/f2fs/dir.c           |  6 ++--
 fs/f2fs/f2fs.h          | 26 ++++++++--------
 fs/f2fs/file.c          | 60 +++++++++++++++++++++++--------------
 fs/f2fs/gc.c            |  8 ++---
 fs/f2fs/gc.h            |  2 +-
 fs/f2fs/hash.c          |  7 +++--
 fs/f2fs/inline.c        | 38 +++++++++++++----------
 fs/f2fs/namei.c         | 23 ++++----------
 fs/f2fs/node.c          | 80 +++++++++++++++++++++++--------------------------
 fs/f2fs/recovery.c      | 30 ++++++++++++++-----
 fs/f2fs/segment.c       | 53 ++------------------------------
 fs/f2fs/segment.h       |  2 +-
 fs/f2fs/super.c         | 32 ++++++++++++++------
 fs/f2fs/xattr.c         |  2 +-
 include/linux/f2fs_fs.h | 16 ++++++++--
 19 files changed, 261 insertions(+), 231 deletions(-)

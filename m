Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbaKVEnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 23:43:05 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34316 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbaKVEnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 23:43:04 -0500
Date: Sat, 22 Nov 2014 04:43:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git fixes
Message-ID: <20141122044302.GA7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Assorted fixes, most in overlayfs land.  Please, pull from the usual
place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Arnd Bergmann (1):
      isofs: avoid unused function warning

Miklos Szeredi (8):
      ovl: rename filesystem type to "overlay"
      ovl: fix remove/copy-up race
      ovl: fix race in private xattr checks
      ovl: allow filenames with comma
      ovl: use lockless_dereference() for upperdentry
      ovl: pass dentry into ovl_dir_read_merged()
      ovl: update MAINTAINERS
      ovl: ovl_dir_fsync() cleanup

Yan, Zheng (1):
      vfs: fix reference leak in d_prune_aliases()

Diffstat:
 Documentation/filesystems/overlayfs.txt |    2 +-
 MAINTAINERS                             |    7 ++--
 fs/Makefile                             |    2 +-
 fs/dcache.c                             |    1 +
 fs/isofs/inode.c                        |   42 ++++++++++-----------
 fs/overlayfs/Kconfig                    |    2 +-
 fs/overlayfs/Makefile                   |    4 +-
 fs/overlayfs/dir.c                      |   31 ++++++++++------
 fs/overlayfs/inode.c                    |   27 +++++++++-----
 fs/overlayfs/readdir.c                  |   39 ++++++++------------
 fs/overlayfs/super.c                    |   61 +++++++++++++++++++++++++------
 11 files changed, 133 insertions(+), 85 deletions(-)

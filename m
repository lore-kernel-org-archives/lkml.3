Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbaKTQp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:45:26 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39887 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887AbaKTQpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:45:25 -0500
Date: Thu, 20 Nov 2014 17:45:31 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Subject: [GIT PULL] overlay filesystem fixes for 3.18
Message-ID: <20141120164531.GB3596@tucsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-current

The biggest change is to rename the filesystem from "overlayfs" to "overlay".
This will allow legacy overlayfs to be easily carried by distros alongside the
new mainline one.  Also fix a couple of copy-up races and allow escaping comma
character in filenames.

Thanks,
Miklos

---
Miklos Szeredi (8):
      ovl: rename filesystem type to "overlay"
      ovl: fix remove/copy-up race
      ovl: fix race in private xattr checks
      ovl: allow filenames with comma
      ovl: use lockless_dereference() for upperdentry
      ovl: pass dentry into ovl_dir_read_merged()
      ovl: update MAINTAINERS
      ovl: ovl_dir_fsync() cleanup

---
 Documentation/filesystems/overlayfs.txt |  2 +-
 MAINTAINERS                             |  7 ++--
 fs/Makefile                             |  2 +-
 fs/overlayfs/Kconfig                    |  2 +-
 fs/overlayfs/Makefile                   |  4 +--
 fs/overlayfs/dir.c                      | 31 ++++++++++-------
 fs/overlayfs/inode.c                    | 27 ++++++++++-----
 fs/overlayfs/readdir.c                  | 39 +++++++++------------
 fs/overlayfs/super.c                    | 61 ++++++++++++++++++++++++++-------
 9 files changed, 111 insertions(+), 64 deletions(-)

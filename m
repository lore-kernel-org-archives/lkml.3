Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693AbaEFPPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:15:53 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:55612 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbaEFPPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:15:49 -0400
Date: Tue, 6 May 2014 17:15:44 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] fuse fixes for 3.15
Message-ID: <20140506151544.GC32527@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

This adds ctime update in the new cached writeback mode and also
fixes/simplifies the mtime update handling.  Support for rename flags (aka
renameat2) is also added to the userspace API.

Thanks,
Miklos
----
Fabian Frederick (1):
      fuse: add __exit to fuse_ctl_cleanup

Maxim Patlasov (6):
      fuse: do not use uninitialized i_mode
      fuse: update mtime on truncate(2)
      fuse: update mtime on open(O_TRUNC) in atomic_o_trunc mode
      fuse: allow ctime flushing to userspace
      fuse: trust kernel i_ctime only
      fuse: clear FUSE_I_CTIME_DIRTY flag on setattr

Miklos Szeredi (9):
      fuse: check fallocate mode
      fuse: fix mtime update error in fsync
      fuse: fuse: fallocate: use file_update_time()
      fuse: clean up fsync
      fuse: add .write_inode
      fuse: fuse: add time_gran to INIT_OUT
      fuse: remove .update_time
      fuse: clear MS_I_VERSION
      fuse: add renameat2 support

---
 fs/fuse/control.c         |   2 +-
 fs/fuse/dir.c             | 146 +++++++++++++++++++++++++++++++---------------
 fs/fuse/file.c            |  84 ++++++++++++++++----------
 fs/fuse/fuse_i.h          |  10 ++--
 fs/fuse/inode.c           |  16 +++--
 include/uapi/linux/fuse.h |  22 ++++++-
 6 files changed, 192 insertions(+), 88 deletions(-)

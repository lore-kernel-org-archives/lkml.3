Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab3GNReI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 13:34:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43241 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab3GNReG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 13:34:06 -0400
Date: Sun, 14 Jul 2013 18:34:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] more vfs.git stuff
Message-ID: <20130714173404.GJ4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	O_TMPFILE ABI changes, Oleg's fput() series, misc cleanups,
including making simple_lookup() usable for filesystems with non-NULL,
which allows to get rid of quite a bit of ugliness.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (8):
      Safer ABI for O_TMPFILE
      rpc_create_*_dir: don't bother with qstr
      __rpc_lookup_create_exclusive: pass string instead of qstr
      configfs: don't open-code d_alloc_name()
      make simple_lookup() usable for filesystems that set ->s_d_op
      efivarfs: we can use simple_lookup() now
      cgroup: we can use simple_lookup() now
      sunrpc: now we can just set ->s_d_op

Andrew Morton (1):
      fs/file_table.c:fput(): add comment

Oleg Nesterov (3):
      fput: turn "list_head delayed_fput_list" into llist_head
      llist: fix/simplify llist_add() and llist_add_batch()
      llist: llist_add() can use llist_add_batch()

Diffstat:
 arch/alpha/include/uapi/asm/fcntl.h  |    2 +-
 arch/parisc/include/uapi/asm/fcntl.h |    2 +-
 arch/sparc/include/uapi/asm/fcntl.h  |    2 +-
 fs/configfs/dir.c                    |   13 +--------
 fs/efivarfs/inode.c                  |   14 +----------
 fs/file_table.c                      |   31 ++++++++++++-----------
 fs/libfs.c                           |    3 +-
 fs/namei.c                           |    2 +-
 fs/open.c                            |    4 +-
 include/linux/fs.h                   |    2 +
 include/linux/llist.h                |   19 +++-----------
 include/linux/sunrpc/rpc_pipe_fs.h   |    4 +-
 include/uapi/asm-generic/fcntl.h     |    8 ++++-
 kernel/cgroup.c                      |   11 +-------
 lib/llist.c                          |   15 ++++-------
 net/sunrpc/cache.c                   |   18 ++++----------
 net/sunrpc/clnt.c                    |   20 ++++++---------
 net/sunrpc/rpc_pipe.c                |   45 +++++++++++----------------------
 18 files changed, 75 insertions(+), 140 deletions(-)

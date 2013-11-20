Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3KTRmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:42:14 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41849 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab3KTRmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:42:12 -0500
Date: Wed, 20 Nov 2013 17:42:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git bits and pieces
Message-ID: <20131120174211.GF10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Apologies for delay; I'd spent the last day hunting down something that
turned out to be a VM leak completely unrelated to this stuff - it's
present in mainline, for starters.  Unreliable reproducers make for fun
bisects ;-/  Anyway, by now I'm absolutely sure that this is a VM bug and
not something I had somehow managed to break, so...]

Assorted bits that got missed in the first pull request + fixes for
a couple of coredump regressions.  Please, pull from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (7):
      dump_align(): fix the dumb braino
      dump_emit(): use __kernel_write(), not vfs_write()
      gfs2: endianness misannotations
      consolidate simple ->d_delete() instances
      take read_seqbegin_or_lock() and friends to seqlock.h
      dcache.c: get rid of pointless macros
      fold try_to_ascend() into the sole remaining caller

Diffstat:
 arch/ia64/kernel/perfmon.c |    8 +----
 fs/9p/vfs_dentry.c         |   19 +---------
 fs/configfs/dir.c          |   12 +------
 fs/coredump.c              |    6 ++--
 fs/dcache.c                |   84 ++++++++++---------------------------------
 fs/efivarfs/super.c        |   11 +-----
 fs/gfs2/lock_dlm.c         |    8 ++--
 fs/gfs2/quota.c            |   23 +++++-------
 fs/gfs2/rgrp.c             |    4 +-
 fs/hostfs/hostfs_kern.c    |   11 +-----
 fs/libfs.c                 |   12 ++++---
 fs/proc/generic.c          |   18 +---------
 fs/proc/namespaces.c       |    8 +----
 include/linux/fs.h         |    2 +
 include/linux/seqlock.h    |   29 +++++++++++++++
 kernel/cgroup.c            |    7 +---
 net/sunrpc/rpc_pipe.c      |   11 +-----
 17 files changed, 86 insertions(+), 187 deletions(-)

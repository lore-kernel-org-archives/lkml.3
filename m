Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3IJQVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:21:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57571 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3IJQVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:21:01 -0400
Date: Tue, 10 Sep 2013 17:21:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs pile 3/many...
Message-ID: <20130910162100.GX13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Waiman's conversion of d_path() and bits related to it, kern_path_mountpoint(),
several cleanups and fixes (exportfs one is -stable fodder, IMO).  There
definitely will be more... ;-/  Please, pull from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (8):
      afs: get rid of redundant ->d_name.len checks
      exportfs: don't assume that ->iterate() won't feed us too long entries
      prune_super(): sb->s_op is never NULL
      Kill indirect include of file.h from eventfd.h, use fdget() in cgroup.c
      take unlazy_walk() into umount_lookup_last()
      rename user_path_umountat() to user_path_mountpoint_at()
      introduce kern_path_mountpoint()
      split read_seqretry_or_unlock(), convert d_walk() to resulting primitives

Ian Kent (1):
      autofs4 - fix device ioctl mount lookup

Waiman Long (1):
      dcache: Translating dentry into pathname without taking rename_lock

Diffstat:
 fs/afs/dir.c            |   24 -----
 fs/autofs4/dev-ioctl.c  |   23 +++---
 fs/dcache.c             |  220 +++++++++++++++++++++++++++++++----------------
 fs/exportfs/expfs.c     |    2 +-
 fs/internal.h           |    3 +
 fs/namei.c              |  112 +++++++++++++-----------
 fs/namespace.c          |    2 +-
 fs/super.c              |    2 +-
 include/linux/eventfd.h |    3 +-
 include/linux/namei.h   |    4 +-
 kernel/cgroup.c         |   33 ++++----
 11 files changed, 241 insertions(+), 187 deletions(-)

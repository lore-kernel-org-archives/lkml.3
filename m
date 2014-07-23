Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbaGWNPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:15:54 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:57370 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbaGWNPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:15:52 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-kernel@vger.kernel.org, hch@infradead.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/7] first iteration of rename2 support
Date: Wed, 23 Jul 2014 15:15:29 +0200
Message-Id: <1406121336-1379-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for rename flags to a couple more filesystems, while gradually
migrating away from ->rename() to ->rename2().

RENAME_NOREPLACE is really easy for the majority (here only btrfs, shmem, hostfs
and cifs are done), so more of the this is coming if this series is well
received.

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git renameat2

Thanks,
Miklos
---

Miklos Szeredi (7):
      vfs: call rename2 if exists
      bad_inode: add ->rename2()
      btrfs: add RENAME_NOREPLACE
      shmem: support RENAME_NOREPLACE
      shmem: support RENAME_EXCHANGE
      hostfs: support rename flags
      cifs: support RENAME_NOREPLACE

---
 fs/bad_inode.c          |  7 ++++---
 fs/btrfs/inode.c        | 12 +++++++++++-
 fs/cifs/cifsfs.c        |  2 +-
 fs/cifs/cifsfs.h        |  4 ++--
 fs/cifs/inode.c         | 14 ++++++++++++--
 fs/ext4/namei.c         |  1 -
 fs/fuse/dir.c           |  7 -------
 fs/hostfs/hostfs.h      |  1 +
 fs/hostfs/hostfs_kern.c | 30 ++++++++++++++++++++----------
 fs/hostfs/hostfs_user.c | 28 ++++++++++++++++++++++++++++
 fs/namei.c              |  5 +++--
 mm/shmem.c              | 32 ++++++++++++++++++++++++++++++--
 12 files changed, 112 insertions(+), 31 deletions(-)


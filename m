Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935574Ab3IEJox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:44:53 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:32951 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933097Ab3IEJov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:44:51 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz
Subject: [PATCH 00/11] [v4] safely drop directory dentry on failed revalidate
Date: Thu,  5 Sep 2013 11:44:33 +0200
Message-Id: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a series for fixing issues with d_drop on a directory dentry with
children and adding support for such dropped directories in fuse.

Address comments: kill ->leave() callback, select_parent() and
__check_submounts_and_drop().

Don't spam everybody: dropped most Cc's.

Thanks,
Miklos

---
Anand Avati (1):
      fuse: drop dentry on failed revalidate

Miklos Szeredi (10):
      vfs: restructure d_genocide()
      vfs: add d_walk()
      vfs: check submounts and drop atomically
      vfs: check unlinked ancestors before mount
      afs: use check_submounts_and_drop()
      gfs2: use check_submounts_and_drop()
      nfs: use check_submounts_and_drop()
      sysfs: use check_submounts_and_drop()
      fuse: use d_materialise_unique()
      fuse: clean up return in fuse_dentry_revalidate()

---
 fs/afs/dir.c           |  10 +-
 fs/dcache.c            | 430 ++++++++++++++++++++++++++++++-------------------
 fs/fuse/dir.c          |  97 ++++++-----
 fs/gfs2/dentry.c       |   9 +-
 fs/internal.h          |   1 +
 fs/namespace.c         |   9 ++
 fs/nfs/dir.c           |   9 +-
 fs/sysfs/dir.c         |  20 +--
 include/linux/dcache.h |   1 +
 9 files changed, 340 insertions(+), 246 deletions(-)


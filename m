Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762681Ab3IDOFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:05:51 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:50472 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab3IDOFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:05:47 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: rwheeler@redhat.com, avati@redhat.com, viro@ZenIV.linux.org.uk
Cc: bfoster@redhat.com, dhowells@redhat.com, eparis@redhat.com,
        raven@themaw.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mszeredi@suse.cz
Subject: [PATCH 00/10] [v3] safely drop directory dentry on failed revalidate
Date: Wed,  4 Sep 2013 16:05:46 +0200
Message-Id: <1378303556-7220-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a series for fixing issues with d_drop on a directory dentry with
children and adding support for such dropped directories in fuse.

This one adds a helper for walking the dentry tree.  This reduces code
duplication and reduces the chances of a bug creeping into one of the instances.

The only user of have_submounts() is now autofs4, but after discussing with Ian
I'm still not sure how we should deal with that.

Thanks,
Miklos

---
Anand Avati (1):
      fuse: drop dentry on failed revalidate

Miklos Szeredi (9):
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
 fs/dcache.c            | 452 +++++++++++++++++++++++++++++++------------------
 fs/fuse/dir.c          |  97 +++++------
 fs/gfs2/dentry.c       |   9 +-
 fs/internal.h          |   1 +
 fs/namespace.c         |   9 +
 fs/nfs/dir.c           |   9 +-
 fs/sysfs/dir.c         |  20 +--
 include/linux/dcache.h |   1 +
 9 files changed, 364 insertions(+), 244 deletions(-)


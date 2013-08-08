Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965867Ab3HHPY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 11:24:59 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:58303 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965835Ab3HHPY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 11:24:57 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: rwheeler@redhat.com, avati@redhat.com, viro@ZenIV.linux.org.uk
Cc: bfoster@redhat.com, dhowells@redhat.com, eparis@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz
Subject: [PATCH 0/9] [RFC v2] safely drop directory dentry on failed revalidate
Date: Thu,  8 Aug 2013 17:24:41 +0200
Message-Id: <1375975490-18673-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a series for fixing issues with d_drop on a directory dentry with
children and adding support for such dropped directories in fuse.

This one fixes a couple of issues I found with the previous incarnation and
split out the filesystem parts into individual patches.

Thanks,
Miklos

---
Anand Avati (1):
      fuse: drop dentry on failed revalidate

Miklos Szeredi (8):
      vfs: check submounts and drop atomically
      vfs: check unlinked ancestors before mount
      afs: use check_submounts_and_drop()
      gfs2: use check_submounts_and_drop()
      nfs: use check_submounts_and_drop()
      sysfs: use check_submounts_and_drop()
      fuse: use d_materialise_unique()
      fuse: clean up return in fuse_dentry_revalidate()

---
 fs/afs/dir.c           |  10 +--
 fs/dcache.c            | 192 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dir.c          |  97 ++++++++++++-------------
 fs/gfs2/dentry.c       |   9 +--
 fs/internal.h          |   1 +
 fs/namespace.c         |   9 +++
 fs/nfs/dir.c           |   9 ++-
 fs/sysfs/dir.c         |  20 +++---
 include/linux/dcache.h |   1 +
 9 files changed, 267 insertions(+), 81 deletions(-)



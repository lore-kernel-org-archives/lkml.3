Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab3HFOaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 10:30:22 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:64902 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3HFOaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 10:30:20 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: rwheeler@redhat.com, avati@redhat.com, viro@ZenIV.linux.org.uk
Cc: bfoster@redhat.com, dhowells@redhat.com, eparis@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, Trond.Myklebust@netapp.com,
        swhiteho@redhat.com, mszeredi@suse.cz
Subject: [PATCH 0/4] [RFC] safely drop directory dentry on failed revalidate
Date: Tue,  6 Aug 2013 16:29:59 +0200
Message-Id: <1375799403-28544-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a series for fixing issues with d_drop on a directory dentry with
children and adding support for such dropped directories in fuse.

I tested the fuse part, but not the other filesystems (AFS, GFS2, NFS, SYSFS).
The changes to filesystems are pretty trivial, though.

Thanks,
Miklos

---
Anand Avati (1):
      fuse: drop dentry on failed revalidate

Miklos Szeredi (3):
      vfs: check submounts and drop atomically
      vfs: check unlinked ancestors before mount
      fuse: use d_materialise_unique()

---
 fs/afs/dir.c           |   6 +-
 fs/dcache.c            | 159 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dir.c          |  76 ++++++++++-------------
 fs/gfs2/dentry.c       |   6 +-
 fs/internal.h          |   1 +
 fs/namespace.c         |   9 +++
 fs/nfs/dir.c           |  10 ++--
 fs/sysfs/dir.c         |   6 +-
 include/linux/dcache.h |   1 +
 9 files changed, 216 insertions(+), 58 deletions(-)



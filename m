Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751046Ab3IGDEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 23:04:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38589 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab3IGDEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 23:04:12 -0400
Date: Sat, 7 Sep 2013 04:04:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs pile 2 (of many)
Message-ID: <20130907030411.GZ13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Mostly Miklos' series this time.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (1):
      constify dcache.c inlined helpers where possible

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

Diffstat:
 fs/afs/dir.c           |   10 +-
 fs/dcache.c            |  411 +++++++++++++++++++++++++++++-------------------
 fs/fuse/dir.c          |   97 ++++++------
 fs/gfs2/dentry.c       |    9 +-
 fs/internal.h          |    1 +
 fs/namespace.c         |   11 +-
 fs/nfs/dir.c           |    9 +-
 fs/sysfs/dir.c         |   20 +--
 include/linux/dcache.h |   13 +-
 9 files changed, 323 insertions(+), 258 deletions(-)

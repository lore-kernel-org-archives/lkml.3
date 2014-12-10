Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbaLJKsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:48:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbaLJKsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:48:01 -0500
Date: Wed, 10 Dec 2014 11:47:55 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Quota improvements and minor cleanups
Message-ID: <20141210104755.GA25671@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

  to get quota improvements and some minor cleanups. The main portion in
the pull request are changes which move i_dquot array from struct inode
into fs-private part of an inode which saves memory for filesystems which
don't use VFS quotas.

Top of the tree is fdf2657bc81b. The full shortlog is:

Anton Blanchard (1):
      quota: Add log level to printk

Jan Kara (12):
      quota: Remove const from function declarations
      quota: Allow each filesystem to specify which quota types it supports
      gfs2: Set allowed quota types
      xfs: Set allowed quota types
      quota: Use function to provide i_dquot pointers
      ext2: Convert to private i_dquot field
      ext3: Convert to private i_dquot field
      ext4: Convert to private i_dquot field
      ocfs2: Convert to private i_dquot field
      reiserfs: Convert to private i_dquot field
      jfs: Convert to private i_dquot field
      vfs: Remove i_dquot field from inode

Markus Elfring (3):
      jbd: Deletion of an unnecessary check before the function call "iput"
      udf: Deletion of unnecessary checks before the function call "iput"
      udf: One function call less in udf_fill_super() after error detection

The diffstat is

 fs/ext2/ext2.h           |  3 +++
 fs/ext2/super.c          | 10 ++++++++
 fs/ext3/ext3.h           |  4 ++++
 fs/ext3/super.c          | 10 ++++++++
 fs/ext4/ext4.h           |  4 ++++
 fs/ext4/super.c          |  8 +++++++
 fs/gfs2/ops_fstype.c     |  1 +
 fs/inode.c               |  3 ---
 fs/jbd/journal.c         |  3 +--
 fs/jfs/jfs_incore.h      |  3 +++
 fs/jfs/super.c           |  9 ++++++++
 fs/ocfs2/inode.h         |  2 ++
 fs/ocfs2/super.c         |  8 +++++++
 fs/quota/dquot.c         | 59 ++++++++++++++++++++++++++----------------------
 fs/quota/quota.c         | 13 +++++++++--
 fs/reiserfs/reiserfs.h   |  4 ++++
 fs/reiserfs/super.c      | 11 +++++++++
 fs/udf/super.c           | 11 ++++-----
 fs/xfs/xfs_super.c       |  1 +
 include/linux/fs.h       |  5 ++--
 include/linux/quota.h    |  5 ++++
 include/linux/quotaops.h |  8 +++----
 22 files changed, 138 insertions(+), 47 deletions(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

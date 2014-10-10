Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaJJIOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 04:14:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56899 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbaJJIOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 04:14:18 -0400
Date: Fri, 10 Oct 2014 10:14:13 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [GIT PULL] UDF and quota changes for 3.18-rc1
Message-ID: <20141010081413.GC3076@quack.suse.cz>
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

to get a few UDF fixes and also a few patches which are preparing
filesystems for support of project quotas in VFS.

Top of the tree is 6174c2eb8ece. The full shortlog is:

Fabian Frederick (1):
      udf: remove redundant sys_tz declaration

Jan Kara (6):
      udf: Fix race between write(2) and close(2)
      ext3: Don't use MAXQUOTAS value
      reiserfs: Don't use MAXQUOTAS value
      ocfs2: Don't use MAXQUOTAS value
      ocfs2: Back out change to use OCFS2_MAXQUOTAS in ocfs2_setattr()
      udf: Fix loading of special inodes

The diffstat is

 fs/ext3/ext3.h          | 12 +++++++-----
 fs/ext3/super.c         | 14 +++++++-------
 fs/ocfs2/file.c         |  2 +-
 fs/ocfs2/quota.h        |  5 ++++-
 fs/ocfs2/quota_global.c |  4 ++--
 fs/ocfs2/quota_local.c  | 33 +++++++++++++++++----------------
 fs/ocfs2/super.c        | 30 +++++++++++++++++-------------
 fs/reiserfs/reiserfs.h  |  5 ++++-
 fs/reiserfs/super.c     | 16 ++++++++--------
 fs/udf/file.c           |  9 ++++++++-
 fs/udf/inode.c          | 14 +++++++++-----
 fs/udf/super.c          | 10 +++++-----
 fs/udf/udfdecl.h        | 13 ++++++++++++-
 fs/udf/udftime.c        |  2 --
 14 files changed, 101 insertions(+), 68 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

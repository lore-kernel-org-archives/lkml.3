Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaHLPNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 11:13:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbaHLPNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 11:13:14 -0400
Date: Tue, 12 Aug 2014 17:13:09 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] Quota, reiserfs, udf updates for 3.17-rc1 (v2)
Message-ID: <20140812151309.GD3270@quack.suse.cz>
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

to get scalability improvements for quota, a few reiserfs fixes, and couple
of misc cleanups (udf, ext2).

Top of the tree is 01777836c870. The full shortlog is:

Andy Shevchenko (1):
      fs/udf: re-use hex_asc_upper_{hi,lo} macros

Chao Yu (1):
      udf: avoid redundant memcpy when writing data in ICB

Fabian Frederick (2):
      udf: use linux/uaccess.h
      fs/quota: kernel-doc warning fixes

Himangi Saraogi (1):
      fs/ext2/super.c: Drop memory allocation cast

Jan Kara (1):
      reiserfs: Fix use after free in journal teardown

Jeff Mahoney (1):
      reiserfs: fix corruption introduced by balance_leaf refactor

Niu Yawei (4):
      quota: protect Q_GETFMT by dqonoff_mutex
      quota: avoid unnecessary dqget()/dqput() calls
      quota: simplify remove_inode_dquot_ref()
      quota: remove dqptr_sem

The diffstat is

 fs/ext2/super.c        |   2 +-
 fs/quota/dquot.c       | 180 ++++++++++++++++++++++---------------------------
 fs/quota/kqid.c        |   2 +-
 fs/quota/netlink.c     |   3 +-
 fs/quota/quota.c       |   6 +-
 fs/reiserfs/do_balan.c | 111 +++++++++++++++++-------------
 fs/reiserfs/journal.c  |  22 ++++--
 fs/reiserfs/lbalance.c |   5 +-
 fs/reiserfs/reiserfs.h |   9 +--
 fs/reiserfs/super.c    |   6 +-
 fs/super.c             |   1 -
 fs/udf/file.c          |  22 +-----
 fs/udf/lowlevel.c      |   2 +-
 fs/udf/super.c         |   2 +-
 fs/udf/symlink.c       |   2 +-
 fs/udf/unicode.c       |   9 ++-
 include/linux/quota.h  |   1 -
 17 files changed, 189 insertions(+), 196 deletions(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

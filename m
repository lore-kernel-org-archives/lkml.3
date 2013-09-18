Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab3IRWxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 18:53:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35226 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab3IRWwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 18:52:55 -0400
Date: Wed, 18 Sep 2013 23:52:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs and fs fixes
Message-ID: <20130918225253.GP13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atomic_open-related fixes (Miklos' series, with EEXIST-related parts replaced
with fix in fs/namei.c:atomic_open() instead of messing with the instances)
+ race fix in autofs + leak on failure exit in 9p.  Please, pull from the
usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (3):
      autofs4: close the races around autofs4_notify_daemon()
      atomic_open: take care of EEXIST in no-open case with O_CREAT|O_EXCL in fs/namei.c
      9p: don't forget to destroy inode cache if fscache registration fails

Miklos Szeredi (5):
      vfs: improve i_op->atomic_open() documentation
      cifs: fix filp leak in cifs_atomic_open()
      gfs2: set FILE_CREATED
      nfs: set FILE_CREATED
      vfs: don't set FILE_CREATED before calling ->atomic_open()

Diffstat:
 Documentation/filesystems/vfs.txt |   14 +++++++-------
 fs/9p/v9fs.c                      |    7 ++++---
 fs/9p/vfs_inode_dotl.c            |    8 +-------
 fs/autofs4/waitq.c                |   13 +++----------
 fs/cifs/dir.c                     |    1 +
 fs/gfs2/inode.c                   |    4 +++-
 fs/namei.c                        |   34 ++++++++++++++++++++++------------
 fs/nfs/dir.c                      |    3 +++
 fs/open.c                         |   21 ++++++++++++++++++---
 9 files changed, 62 insertions(+), 43 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbaEHVMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 17:12:22 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:10199 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753994AbaEHVMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 17:12:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApxSAD/ya1N5LL1sPGdsb2JhbABZgwZPh3ikIQEBAQEBAQaaFYEUFwMBAQEBODWCUxMcIxgkNAUlAwctiEDQfxaFQIh8HYMUgRUEhUmTbpZEKw
Date: Fri, 9 May 2014 07:12:17 +1000
From: Dave Chinner <david@fromorbit.com>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: [GIT PULL] xfs: fixes for 3.15-rc5
Message-ID: <20140508211217.GC26353@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you please pull the updates listed below? The main fix is adding
support for default ACLs on O_TMPFILE opened inodes to bring XFS into
line with other filesystems. Metadata CRCs are now also considered
well enough tested to be fully supported, so we're removing the
shouty warnings issued at mount time for filesystems with that
format. And there's transaction block reservation overrun fix.

BTW, will GPG signing these pull requests cause you problems? I've
been signing everything "official" I send as the XFS maintainer
(e.g. notifications of tree updates) and I figured that pull
requests are about as "official" as it gets. The tag is signed, so
I'm not particularly worried either way...

-Dave.

The following changes since commit 330033d697ed8d296fa52b5303db9d802ad901cc:

  xfs: fix tmpfile/selinux deadlock and initialize security (2014-04-17 08:15:30 +1000)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git xfs-fixes-for-3.15-rc5

for you to fetch changes up to 8275cdd0e7ac550dcce2b3ef6d2fb3b808c1ae59:

  xfs: remote attribute overwrite causes transaction overrun (2014-05-06 07:37:31 +1000)

----------------------------------------------------------------
Fixes for 3.15-rc5:
- fix a remote attribute size calculation bug that leads to a
  transaction overrun
- add default ACLs to O_TMPFILE files
- Remove the EXPERIMENTAL tag from filesystems with metadata CRC
  support

----------------------------------------------------------------
Brian Foster (1):
      xfs: initialize default acls for ->tmpfile()

Dave Chinner (2):
      xfs: fully support v5 format filesystems
      xfs: remote attribute overwrite causes transaction overrun

 fs/xfs/xfs_attr.c        |   24 +++++++++++++++++++-
 fs/xfs/xfs_attr_leaf.c   |   21 +++++++++---------
 fs/xfs/xfs_attr_list.c   |    1 +
 fs/xfs/xfs_attr_remote.c |    8 ++++---
 fs/xfs/xfs_da_btree.h    |    2 ++
 fs/xfs/xfs_iops.c        |   55 ++++++++++++++++++++++++----------------------
 fs/xfs/xfs_log.c         |   10 +++++----
 fs/xfs/xfs_mount.c       |    2 --
 fs/xfs/xfs_sb.c          |    4 ----
 9 files changed, 77 insertions(+), 50 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

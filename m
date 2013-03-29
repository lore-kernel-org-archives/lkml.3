Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab3C2RrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 13:47:12 -0400
Received: from dkim2.fusionio.com ([66.114.96.54]:40847 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268Ab3C2RrL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 13:47:11 -0400
X-ASG-Debug-ID: 1364579229-03d6a52ac0157c70001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <20130329174706.4227.39785@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
User-Agent: alot/0.3.4
Subject: [GIT PULL] Btrfs updates
Date: Fri, 29 Mar 2013 13:47:06 -0400
X-ASG-Orig-Subj: [GIT PULL] Btrfs updates
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1364579229
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.126596
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

We've had a busy two weeks of bug fixing.  The biggest patches in here
are some long standing early-enospc problems (Josef) and a very old race
where compression and mmap combine forces to lose writes (me).  I'm
fairly sure the mmap bug goes all the way back to the introduction of
the compression code, which is proof that fsx doesn't trigger every
possible mmap corner after all.

I'm sure you'll notice one of these is from this morning, it's a small
and isolated use-after-free fix in our scrub error reporting.  I double
checked it here.

Josef Bacik (6) commits (+90/-18):
    Btrfs: hold the ordered operations mutex when waiting on ordered extents (+2/-0)
    Btrfs: don't drop path when printing out tree errors in scrub (+2/-1)
    Btrfs: fix space leak when we fail to reserve metadata space (+41/-6)
    Btrfs: fix space accounting for unlink and rename (+2/-4)
    Btrfs: limit the global reserve to 512mb (+1/-1)
    Btrfs: handle a bogus chunk tree nicely (+42/-6)

Jan Schmidt (2) commits (+24/-16):
    Btrfs: fix EIO from btrfs send in is_extent_unchanged for punched holes (+4/-6)
    Btrfs: fix locking on ROOT_REPLACE operations in tree mod log (+20/-10)

Wang Shilong (2) commits (+10/-2):
    Btrfs: fix double free in the btrfs_qgroup_account_ref() (+1/-2)
    Btrfs: fix missing qgroup reservation before fallocating (+9/-0)

Miao Xie (2) commits (+5/-3):
    Btrfs: fix wrong return value of btrfs_lookup_csum() (+3/-1)
    Btrfs: fix wrong reservation of csums (+2/-2)

Chris Mason (1) commits (+49/-0):
    Btrfs: fix race between mmap writes and compression

Liu Bo (1) commits (+1/-1):
    Btrfs: update to use fs_state bit

Tsutomu Itoh (1) commits (+9/-3):
    Btrfs: fix memory leak in btrfs_create_tree()

Total: (15) commits

 fs/btrfs/ctree.c        | 30 ++++++++++++------
 fs/btrfs/disk-io.c      | 14 ++++++---
 fs/btrfs/extent-tree.c  | 84 ++++++++++++++++++++++++++++++++++++++++++-------
 fs/btrfs/extent_io.c    | 33 +++++++++++++++++++
 fs/btrfs/extent_io.h    |  2 ++
 fs/btrfs/file-item.c    |  6 ++--
 fs/btrfs/file.c         |  9 ++++++
 fs/btrfs/inode.c        | 22 ++++++++++---
 fs/btrfs/ordered-data.c |  2 ++
 fs/btrfs/qgroup.c       |  3 +-
 fs/btrfs/scrub.c        |  3 +-
 fs/btrfs/send.c         | 10 +++---
 fs/btrfs/volumes.c      | 13 +++++++-
 13 files changed, 188 insertions(+), 43 deletions(-)

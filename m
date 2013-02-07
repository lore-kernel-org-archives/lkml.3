Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab3BGAVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 19:21:18 -0500
Received: from dkim1.fusionio.com ([66.114.96.53]:46651 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758087Ab3BGAVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 19:21:16 -0500
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Feb 2013 19:21:16 EST
X-ASG-Debug-ID: 1360196008-0421b51e6f02930001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Wed, 6 Feb 2013 19:13:26 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes
Message-ID: <20130207001326.GA21679@shiny>
X-ASG-Orig-Subj: [GIT PULL] Btrfs fixes
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1360196008
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.34
X-Barracuda-Spam-Status: No, SCORE=0.34 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=CN_BODY_332, SH_BIG5_05413_BODY_104
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.122020
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.12 CN_BODY_332            BODY: CN_BODY_332
	0.21 SH_BIG5_05413_BODY_104 BODY: Body: contain "UNSUBSCRIBE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ sorry, my lbdb seems to really like linux-kernel@vger.kerrnel.org,
fixed for real this time ]

Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

We've got corner cases for updating i_size that ceph was hitting, error
handling for quotas when we run out of space, a very subtle snapshot
deletion race, a crash while removing devices, and one deadlock between
subvolume creation and the sb_internal code (thanks lockdep).

Josef Bacik (3) commits (+12/-4):
    Btrfs: do not merge logged extents if we've removed them from the tree (+2/-1)
    Btrfs: fix possible stale data exposure (+1/-1)
    Btrfs: fix missing i_size update (+9/-2)

Miao Xie (2) commits (+21/-9):
    Btrfs: fix missing release of the space/qgroup reservation in start_transaction() (+19/-8)
    Btrfs: fix wrong sync_writers decrement in btrfs_file_aio_write() (+2/-1)

Jan Schmidt (1) commits (+10/-12):
    Btrfs: fix EDQUOT handling in btrfs_delalloc_reserve_metadata

Liu Bo (1) commits (+38/-9):
    Btrfs: fix race between snapshot deletion and getting inode

Chris Mason (1) commits (+4/-1):
    Btrfs: move d_instantiate outside the transaction during mksubvol

Eric Sandeen (1) commits (+2/-1):
    btrfs: don't try to notify udev about missing devices

Total: (9) commits

 fs/btrfs/extent-tree.c  | 22 ++++++++++------------
 fs/btrfs/extent_map.c   |  3 ++-
 fs/btrfs/file.c         | 25 ++++++++++++++++++++-----
 fs/btrfs/ioctl.c        |  5 ++++-
 fs/btrfs/ordered-data.c | 13 ++++++++++---
 fs/btrfs/scrub.c        | 25 ++++++++++++++++++++-----
 fs/btrfs/transaction.c  | 27 +++++++++++++++++++--------
 fs/btrfs/volumes.c      |  3 ++-
 8 files changed, 87 insertions(+), 36 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

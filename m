Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3CQMet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 08:34:49 -0400
Received: from dkim1.fusionio.com ([66.114.96.53]:34589 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3CQMeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 08:34:46 -0400
X-ASG-Debug-ID: 1363523685-03d6a52ac112be0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Sun, 17 Mar 2013 08:34:44 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes
Message-ID: <20130317123444.GA3300@shiny.masoncoding.com>
X-ASG-Orig-Subj: [GIT PULL] Btrfs fixes
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1363523685
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.125448
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

My for-linus branch has some btrfs fixes:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Eric's rcu barrier patch fixes a long standing problem with our unmount
code hanging on to devices in workqueue helpers.  Liu Bo nailed down a
difficult assertion for in-memory extent mappings.

Liu Bo (4) commits (+9/-7):
    Btrfs: get better concurrency for snapshot-aware defrag work (+3/-0)
    Btrfs: fix warning when creating snapshots (+5/-6)
    Btrfs: fix warning of free_extent_map (+1/-0)
    Btrfs: remove btrfs_try_spin_lock (+0/-1)

Josef Bacik (1) commits (+4/-1):
    Btrfs: return EIO if we have extent tree corruption

Eric Sandeen (1) commits (+6/-0):
    btrfs: use rcu_barrier() to wait for bdev puts at unmount

Wang Shilong (1) commits (+6/-4):
    Btrfs: return as soon as possible when edquot happens

Total: (7) commits (+25/-12)

 fs/btrfs/extent-tree.c |  5 ++++-
 fs/btrfs/file.c        |  1 +
 fs/btrfs/inode.c       |  3 +++
 fs/btrfs/locking.h     |  1 -
 fs/btrfs/qgroup.c      | 10 ++++++----
 fs/btrfs/transaction.c | 11 +++++------
 fs/btrfs/volumes.c     |  6 ++++++
 7 files changed, 25 insertions(+), 12 deletions(-)

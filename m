Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3KUSf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 13:35:27 -0500
Received: from dkim1.fusionio.com ([66.114.96.53]:42683 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab3KUSfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 13:35:25 -0500
X-ASG-Debug-ID: 1385058924-0421b529bb2bfe0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Message-ID: <20131121183508.5312.64818@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
User-Agent: alot/0.3.4
Subject: [GIT PULL] Btrfs
Date: Thu, 21 Nov 2013 13:35:08 -0500
X-ASG-Orig-Subj: [GIT PULL] Btrfs
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas1.int.fusionio.com[10.101.1.40]
X-Barracuda-Start-Time: 1385058924
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.142504
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

You'll notice the last two commits were recently rebased, these were
just fixing a typo in the new documentation.

Almost all of these are bug fixes.  Dave Sterba's documentation update
is the big exception because he removed our promises to set any machine
running Btrfs on fire.

Ilya Dryomov (3) commits (+13/-5):
    Btrfs: do not inc uncorrectable_errors counter on ro scrubs (+4/-2)
    Btrfs: disable online raid-repair on ro mounts (+8/-3)
    Btrfs: fix __btrfs_start_workers retval (+1/-0)

Josef Bacik (3) commits (+5/-3):
    Btrfs: only drop modified extents if we logged the whole inode (+1/-1)
    Btrfs: don't BUG_ON() if we get an error walking backrefs (+2/-1)
    Btrfs: make sure to copy everything if we rename (+2/-1)

David Sterba (3) commits (+27/-22):
    Documentation: filesystems: add new btrfs mount options (+11/-1)
    Documentation: filesystems: update btrfs tools section (+6/-16)
    btrfs: update kconfig help text (+10/-5)

Liu Bo (2) commits (+3/-22):
    Btrfs: avoid heavy operations in btrfs_commit_super (+1/-20)
    Btrfs: fix lockdep error in async commit (+2/-2)

Stefan Behrens (1) commits (+17/-8):
    Btrfs: print bytenr instead of page pointer in check-int

Anand Jain (1) commits (+1/-1):
    btrfs: fix typo in the log message

Filipe David Borba Manana (1) commits (+1/-1):
    Btrfs: don't wait for ordered data outside desired range

Wang Shilong (1) commits (+0/-6):
    Btrfs: remove dead codes from ctree.h

Akinobu Mita (1) commits (+1/-1):
    btrfs: fix bio_size_ok() for max_sectors > 0xffff

Miao Xie (1) commits (+1/-0):
    Btrfs: fix list delete warning when removing ordered root from the list

Steven Rostedt (1) commits (+4/-3):
    btrfs: Use trace condition for get_extent tracepoint

Total: (18) commits (+73/-72)

 Documentation/filesystems/btrfs.txt | 34 +++++++++++++++++-----------------
 fs/btrfs/Kconfig                    | 15 ++++++++++-----
 fs/btrfs/async-thread.c             |  1 +
 fs/btrfs/check-integrity.c          | 25 +++++++++++++++++--------
 fs/btrfs/ctree.h                    |  6 ------
 fs/btrfs/dev-replace.c              |  2 +-
 fs/btrfs/disk-io.c                  | 21 +--------------------
 fs/btrfs/extent_io.c                | 11 ++++++++---
 fs/btrfs/inode.c                    |  6 +++---
 fs/btrfs/ordered-data.c             |  3 ++-
 fs/btrfs/scrub.c                    |  6 ++++--
 fs/btrfs/transaction.c              |  4 ++--
 fs/btrfs/tree-log.c                 |  5 +++--
 fs/btrfs/volumes.c                  |  2 +-
 include/trace/events/btrfs.h        |  4 +++-
 15 files changed, 73 insertions(+), 72 deletions(-)

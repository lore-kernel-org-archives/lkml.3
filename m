Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728Ab3CIAik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 19:38:40 -0500
Received: from dkim2.fusionio.com ([66.114.96.54]:59951 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab3CIAii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 19:38:38 -0500
X-ASG-Debug-ID: 1362789515-03d6a5521e031b0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Fri, 8 Mar 2013 19:38:26 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs updates
Message-ID: <20130309003826.GB21566@shiny.masoncoding.com>
X-ASG-Orig-Subj: [GIT PULL] Btrfs updates
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1362789515
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.124653
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please grab my for-linus:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

These are scattered fixes and one performance improvement.  The biggest
functional change is in how we throttle metadata changes.  The new code
bumps our average file creation rate up by ~13% in fs_mark, and lowers
CPU usage.

Stefan bisected out a regression in our allocation code that made
balance loop on extents larger than 256MB.

Liu Bo (6) commits (+71/-19):
    Btrfs: build up error handling for merge_reloc_roots (+35/-12)
    Btrfs: check for NULL pointer in updating reloc roots (+2/-0)
    Btrfs: avoid deadlock on transaction waiting list (+7/-0)
    Btrfs: free all recorded tree blocks on error (+6/-3)
    Btrfs: do not BUG_ON on aborted situation (+12/-3)
    Btrfs: do not BUG_ON in prepare_to_reloc (+9/-1)

Chris Mason (2) commits (+96/-63):
    Btrfs: enforce min_bytes parameter during extent allocation (+4/-2)
    Btrfs: improve the delayed inode throttling (+92/-61)

Miao Xie (2) commits (+45/-39):
    Btrfs: fix unclosed transaction handler when the async transaction commitment fails (+4/-0)
    Btrfs: fix wrong handle at error path of create_snapshot() when the commit fails (+41/-39)

Stefan Behrens (1) commits (+0/-8):
    Btrfs: allow running defrag in parallel to administrative tasks

Ilya Dryomov (1) commits (+5/-0):
    Btrfs: fix a mismerge in btrfs_balance()

Josef Bacik (1) commits (+4/-1):
    Btrfs: use set_nlink if our i_nlink is 0

Total: (13) commits (+221/-130)

 fs/btrfs/delayed-inode.c | 151 ++++++++++++++++++++++++++++-------------------
 fs/btrfs/delayed-inode.h |   2 +
 fs/btrfs/disk-io.c       |  16 +++--
 fs/btrfs/inode.c         |   6 +-
 fs/btrfs/ioctl.c         |  18 ++----
 fs/btrfs/relocation.c    |  74 +++++++++++++++++------
 fs/btrfs/transaction.c   |  65 ++++++++++++--------
 fs/btrfs/tree-log.c      |   5 +-
 fs/btrfs/volumes.c       |  14 ++++-
 9 files changed, 221 insertions(+), 130 deletions(-)

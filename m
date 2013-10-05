Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab3JERhJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 13:37:09 -0400
Received: from dkim1.fusionio.com ([66.114.96.53]:39953 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab3JERhG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 13:37:06 -0400
X-ASG-Debug-ID: 1380994625-0421b50f4ec0be0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <20131005173659.12433.93614@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
User-Agent: alot/0.3.4
Subject: [GIT PULL] Btrfs
Date: Sat, 5 Oct 2013 13:36:59 -0400
X-ASG-Orig-Subj: [GIT PULL] Btrfs
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas2.int.fusionio.com[10.101.1.41]
X-Barracuda-Start-Time: 1380994625
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.141204
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

I've merged my for-linus up to 3.12-rc3 because the top commit is only
meant for 3.12.  The rest of the fixes are also available in my master
branch on top of my last 3.11 based pull.

This is a small collection of fixes, including a regression fix from Liu
Bo that solves rare crashes with compression on.

Ilya Dryomov (2) commits (+28/-11):
    Btrfs: fix a use-after-free bug in btrfs_dev_replace_finishing (+7/-5)
    Btrfs: eliminate races in worker stopping code (+21/-6)

Darrick J. Wong (1) commits (+8/-0):
    btrfs: Fix crash due to not allocating integrity data for a bioset

Liu Bo (1) commits (+1/-1):
    Btrfs: fix crash of compressed writes

Josef Bacik (1) commits (+2/-5):
    Btrfs: fix transid verify errors when recovering log tree

Total: (5) commits (+39/-17)

 fs/btrfs/async-thread.c | 25 +++++++++++++++++++------
 fs/btrfs/async-thread.h |  2 ++
 fs/btrfs/dev-replace.c  |  5 +----
 fs/btrfs/extent_io.c    | 10 +++++++++-
 fs/btrfs/transaction.c  |  7 ++-----
 fs/btrfs/volumes.c      |  7 ++++++-
 6 files changed, 39 insertions(+), 17 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab3JLBBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 21:01:37 -0400
Received: from dkim2.fusionio.com ([66.114.96.54]:53350 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab3JLBBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 21:01:36 -0400
X-ASG-Debug-ID: 1381539695-03d6a50f5f21dbe0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <20131012010129.4917.1914@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
User-Agent: alot/0.3.4
Subject: [GIT PULL] Btrfs
Date: Fri, 11 Oct 2013 21:01:29 -0400
X-ASG-Orig-Subj: [GIT PULL] Btrfs
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: UNKNOWN[10.101.1.41]
X-Barracuda-Start-Time: 1381539695
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.141387
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

We've got more bug fixes in my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

One of these fixes another corner of the compression oops from last
time.  Miao nailed down some problems with concurrent snapshot deletion
and drive balancing.

I kept out one of his patches for more testing, but these are all
stable.

Josef Bacik (2) commits (+5/-9):
    Btrfs: limit delalloc pages outside of find_delalloc_range (+4/-8)
    Btrfs: use right root when checking for hash collision (+1/-1)

Miao Xie (2) commits (+20/-12):
    Btrfs: fix oops caused by the space balance and dead roots (+17/-7)
    Btrfs: insert orphan roots into fs radix tree (+3/-5)

Total: (4) commits (+25/-21)

 fs/btrfs/disk-io.c    |  9 +++++----
 fs/btrfs/disk-io.h    | 13 +++++++++++--
 fs/btrfs/extent_io.c  | 12 ++++--------
 fs/btrfs/inode.c      |  2 +-
 fs/btrfs/relocation.c |  2 +-
 fs/btrfs/root-tree.c  |  8 +++-----
 6 files changed, 25 insertions(+), 21 deletions(-)

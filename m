Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaH2Cso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 22:48:44 -0400
Received: from imap.thunk.org ([74.207.234.97]:55069 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbaH2Csn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 22:48:43 -0400
Date: Thu, 28 Aug 2014 22:48:38 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: torvalds@linux-foundation.org
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 bug fixes for 3.17
Message-ID: <20140829024838.GA2734@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	torvalds@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to d80d448c6c5bdd32605b78a60fe8081d82d4da0f:

  ext4: fix same-dir rename when inline data directory overflows (2014-08-28 22:22:29 -0400)

----------------------------------------------------------------
Ext4 bug fixes for 3.17, to provide better handling of memory
allocation failures, and to fix some journaling bugs involving journal
checksums and FALLOC_FL_ZERO_RANGE.

----------------------------------------------------------------
Darrick J. Wong (3):
      jbd2: fix infinite loop when recovering corrupt journal blocks
      jbd2: fix descriptor block size handling errors with journal_csum
      ext4: fix same-dir rename when inline data directory overflows

Dmitry Monakhov (4):
      ext4: move i_size,i_disksize update routines to helper function
      ext4: fix incorect journal credits reservation in ext4_zero_range
      ext4: fix transaction issues for ext4_fallocate and ext_zero_range
      ext4: update i_disksize coherently with block allocation on error path

Theodore Ts'o (2):
      ext4: propagate errors up to ext4_find_entry()'s callers
      ext4: fix BUG_ON in mb_free_blocks()

 fs/ext4/ext4.h       | 18 ++++++++++-
 fs/ext4/extents.c    | 88 +++++++++++++++++++++++++++---------------------------
 fs/ext4/inode.c      | 44 ++++++++++-----------------
 fs/ext4/mballoc.c    |  5 ++++
 fs/ext4/namei.c      | 56 ++++++++++++++++++++++++++++++----
 fs/ext4/super.c      |  5 ++--
 fs/jbd2/commit.c     | 21 +++++++------
 fs/jbd2/journal.c    | 56 ++++++++++++++++++++++------------
 fs/jbd2/recovery.c   | 33 ++++++++++++--------
 fs/jbd2/revoke.c     |  6 ++--
 include/linux/jbd2.h | 30 +++++++++++++++----
 11 files changed, 233 insertions(+), 129 deletions(-)

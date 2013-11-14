Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab3KNAca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 19:32:30 -0500
Received: from imap.thunk.org ([74.207.234.97]:58309 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab3KNAcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 19:32:21 -0500
Date: Wed, 13 Nov 2013 19:32:15 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: [GIT PULL] ext4 changes for 3.13
Message-ID: <20131114003215.GA31632@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 61e6cfa80de5760bbe406f4e815b7739205754d2:

  Linux 3.12-rc5 (2013-10-13 15:41:28 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 3f61c0cc706d5c0beee7af17ffeb706403cf513c:

  ext4: add prototypes for macro-generated functions (2013-11-11 22:40:40 -0500)

----------------------------------------------------------------
Ext4 updates for 3.13.  Mostly bug fixes and cleanups.

----------------------------------------------------------------
Andreas Dilger (2):
      ext4: return non-zero st_blocks for inline data
      ext4: add prototypes for macro-generated functions

Azat Khuzhin (1):
      ext4: drop set but otherwise unused variable from ext4_add_dirent_to_inline()

BoxiLiu (1):
      ext4: change ext4_read_inline_dir() to return 0 on success

Darrick J. Wong (1):
      ext4: don't count free clusters from a corrupt block group

Eric Sandeen (2):
      ext4: remove unreachable code in ext4_can_extents_be_merged()
      ext4: remove unreachable code after ext4_can_extents_be_merged()

Jan Kara (2):
      ext4: fix assertion in ext4_add_complete_io()
      ext4: fixup kerndoc annotation of mpage_map_and_submit_extent()

Lukas Czerner (1):
      ext4: fix FITRIM in no journal mode

Ming Lei (2):
      ext4: fix performance regression in ext4_writepages
      ext4: pair trace_ext4_writepages & trace_ext4_writepages_result

Theodore Ts'o (3):
      ext4: add ratelimiting to ext4 messages
      ext4: avoid bh leak in retry path of ext4_expand_extra_isize_ea()
      ext4: use prandom_u32() instead of get_random_bytes()

 fs/ext4/balloc.c  |  13 +++++-
 fs/ext4/ext4.h    |  17 +++++++
 fs/ext4/extents.c |  35 +-------------
 fs/ext4/ialloc.c  |   2 +-
 fs/ext4/inline.c  |   3 +-
 fs/ext4/inode.c   |  54 +++++++++++++---------
 fs/ext4/mballoc.c |   4 +-
 fs/ext4/mmp.c     |   2 +-
 fs/ext4/page-io.c |   5 +-
 fs/ext4/super.c   | 159 ++++++++++++++++++++++++++++++++++++++-------------------------
 fs/ext4/xattr.c   |   1 +
 11 files changed, 168 insertions(+), 127 deletions(-)

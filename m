Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425AbaJaVtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 17:49:55 -0400
Received: from imap.thunk.org ([74.207.234.97]:55783 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759875AbaJaVtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 17:49:52 -0400
Date: Fri, 31 Oct 2014 17:49:49 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: [GIT PULL] ext4 bug fixes for 3.18
Message-ID: <20141031214949.GA644@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
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

The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to ae9e9c6aeea6f91ccb4fb369d7dd8f1a8b5f6a58:

  ext4: make ext4_ext_convert_to_initialized() return proper number of blocks (2014-10-30 10:53:17 -0400)

----------------------------------------------------------------
A set of miscellaneous ext4 bug fixes for 3.18.

----------------------------------------------------------------
Darrick J. Wong (3):
      ext4: enable journal checksum when metadata checksum feature enabled
      ext4: disallow changing journal_csum option during remount
      ext4: remove extent status procfs files if journal load fails

Dmitry Monakhov (1):
      ext4: prevent bugon on race between write/fcntl

Jan Kara (5):
      ext4: fix overflow when updating superblock backups after resize
      ext4: fix oops when loading block bitmap failed
      ext4: bail out from make_indexed_dir() on first error
      ext4: bail early when clearing inode journal flag fails
      ext4: make ext4_ext_convert_to_initialized() return proper number of blocks

Theodore Ts'o (1):
      jbd2: use a better hash function for the revoke table

 fs/ext4/extents.c |  9 ++++-----
 fs/ext4/file.c    |  2 +-
 fs/ext4/ialloc.c  |  4 ++++
 fs/ext4/inode.c   |  7 ++++++-
 fs/ext4/namei.c   | 28 ++++++++++++++++++----------
 fs/ext4/resize.c  |  2 +-
 fs/ext4/super.c   | 17 +++++++++++++++--
 fs/jbd2/revoke.c  | 10 ++--------
 8 files changed, 51 insertions(+), 28 deletions(-)

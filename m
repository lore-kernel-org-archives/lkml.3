Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbbAEWyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:54:22 -0500
Received: from imap.thunk.org ([74.207.234.97]:52944 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbbAEWyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:54:20 -0500
Date: Mon, 5 Jan 2015 17:54:18 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 bug fixes for 3.19-rc3
Message-ID: <20150105225418.GA1086@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
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

The following changes since commit 50db71abc529c48b21f4c3034d3cff27cfb25795:

  ext4: ext4_da_convert_inline_data_to_extent drop locked page after error (2014-12-05 21:37:15 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to 363307e6e561cde78572fd22e7fd00cd3e5adb02:

  ext4: remove spurious KERN_INFO from ext4_warning call (2015-01-02 15:31:14 -0500)

----------------------------------------------------------------
Revert a potential seek_data/hole regression which shows up when using
ext4 to handle ext3 file systems, plus two minor bug fixes.

----------------------------------------------------------------
Jakub Wilk (1):
      ext4: remove spurious KERN_INFO from ext4_warning call

Theodore Ts'o (2):
      ext4: prevent online resize with backup superblock
      Revert "ext4: fix suboptimal seek_{data,hole} extents traversial"

 fs/ext4/extents.c |   4 +-
 fs/ext4/file.c    | 220 +++++++++++++++++++++++++++++---------------------------
 fs/ext4/resize.c  |  24 +++----
 fs/ext4/super.c   |   2 +-
 4 files changed, 129 insertions(+), 121 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab3GTA33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 20:29:29 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39378 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab3GTA32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 20:29:28 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] more ext4 bug fixes
cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 19 Jul 2013 20:29:24 -0400
Message-ID: <nsxy592axaz.fsf@lambda.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following changes since commit e7676a704ee0a1ef71a6b23760b5a8f6896cb1a1:

  ext4: don't allow ext4_free_blocks() to fail due to ENOMEM (2013-07-13 00:40:35 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 63b999685cb372e24eb73f255cd73547026370fd:

  ext4: call ext4_es_lru_add() after handling cache miss (2013-07-16 10:28:47 -0400)

----------------------------------------------------------------
Fixes for 3.11-rc2, sent at 5pm, in the professoinal style.  :-)

----------------------------------------------------------------
Theodore Ts'o (5):
      ext4: fix error handling in ext4_ext_truncate()
      ext4: simplify calculation of blocks to free on error
      ext4: make the extent_status code more robust against ENOMEM failures
      ext4: yield during large unlinks
      ext4: call ext4_es_lru_add() after handling cache miss

 fs/ext4/extents.c        | 23 +++++++++++++++++++----
 fs/ext4/extents_status.c | 51 +++++++++++++++++++++++++++++++++++++++------------
 fs/ext4/inode.c          |  7 ++-----
 3 files changed, 60 insertions(+), 21 deletions(-)

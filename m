Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab3APXQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 18:16:06 -0500
Received: from relay2.sgi.com ([192.48.179.30]:56989 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752034Ab3APXQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 18:16:04 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.8-rc4
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20130116231602.BFAEB4266DC@whiskey.americas.sgi.com>
Date: Wed, 16 Jan 2013 17:16:02 -0600 (CST)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

   Please pull these fixes for XFS.  There are fixes for compound
   buffers, a fix for quotas, and a fix for dirv2 corruption introduced
   in the 3.8 merge window.

Thanks,
	Ben

The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565:

  Linux 3.8-rc1 (2012-12-21 17:19:00 -0800)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/for-linus-v3.8-rc4

for you to fetch changes up to 37f13561de6039b3a916d1510086030d097dea0f:

  xfs: recalculate leaf entry pointer after compacting a dir2 block (2013-01-16 16:08:55 -0600)

----------------------------------------------------------------
xfs: bugfixes for 3.8-rc4

- fix(es) for compound buffers
- fix for dquot soft timer asserts due to overflow of d_blk_softlimit
- fix for regression in dir v2 code introduced in commit 20f7e9f3

----------------------------------------------------------------
Brian Foster (1):
      xfs: remove int casts from debug dquot soft limit timer asserts

Eric Sandeen (1):
      xfs: recalculate leaf entry pointer after compacting a dir2 block

Mark Tinguely (4):
      xfs: use b_maps[] for discontiguous buffers
      xfs: rename bli_format to avoid confusion with bli_formats
      xfs: fix segment in xfs_buf_item_format_segment
      xfs: fix the multi-segment log buffer format

 fs/xfs/xfs_buf.c         | 12 ++++++------
 fs/xfs/xfs_buf.h         |  6 +++---
 fs/xfs/xfs_buf_item.c    | 49 ++++++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_buf_item.h    |  2 +-
 fs/xfs/xfs_dir2_block.c  |  6 ++++--
 fs/xfs/xfs_qm_syscalls.c |  4 ++--
 fs/xfs/xfs_trans_buf.c   | 27 ++++++++++++++------------
 7 files changed, 64 insertions(+), 42 deletions(-)

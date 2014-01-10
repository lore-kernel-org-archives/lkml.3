Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaAJTEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 14:04:13 -0500
Received: from relay2.sgi.com ([192.48.179.30]:39276 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750983AbaAJTEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 14:04:11 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS bugfixes for 3.13-rc8
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20140110190406.DAB254266DC@whiskey.americas.sgi.com>
Date: Fri, 10 Jan 2014 13:04:06 -0600 (CST)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these fixes for XFS.  Here we have a bugfix for an
off-by-one in the remote attribute verifier that results in a forced
shutdown which you can hit with v5 superblock by creating a 64k xattr,
and a fix for a missing destroy_work_on_stack() in the allocation
worker.  It's a bit late, but they are both fairly straightforward.

Thanks,
	Ben

The following changes since commit ac8809f9ab01a73de1a47b5a37bd8dcca8712fb3:

  xfs: abort metadata writeback on permanent errors (2013-12-17 09:40:23 -0600)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/xfs-for-linus-v3.13-rc8

for you to fetch changes up to 1f4a63bf019524c96e79f088cd717b96ef00a249:

  xfs: Calling destroy_work_on_stack() to pair with INIT_WORK_ONSTACK() (2014-01-10 12:39:38 -0600)

----------------------------------------------------------------
xfs: bugfixes for 3.13-rc8

- fix off-by-one in xfs_attr3_rmt_verify
- fix missing destroy_work_on_stack() in xfs_bmapi_allocate

----------------------------------------------------------------
Chuansheng Liu (1):
      xfs: Calling destroy_work_on_stack() to pair with INIT_WORK_ONSTACK()

Jie Liu (1):
      xfs: fix off-by-one error in xfs_attr3_rmt_verify

 fs/xfs/xfs_attr_remote.c | 2 +-
 fs/xfs/xfs_bmap_util.c   | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

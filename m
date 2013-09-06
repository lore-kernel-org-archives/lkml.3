Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750775Ab3IFEHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 00:07:15 -0400
Received: from mdfmta010.mxout.tch.inty.net ([91.221.169.51]:47309 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750710Ab3IFEHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 00:07:13 -0400
From: Phillip Lougher <phillip@squashfs.org.uk>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Subject: [PATCH 0/5] Squashfs: extra sanity checks and sanity check fixes	
Date: Fri,  6 Sep 2013 04:54:36 +0100
Message-Id: <1378439682-12830-1-git-send-email-phillip@squashfs.org.uk>
X-Mailer: git-send-email 1.7.10.4
X-MDF-HostID: 19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following on from the "Squashfs: sanity check information from disk"
patch from Dan Carpenter, I have added a couple more sanity checks,
and fixed a couple of existing sanity checks (including the patch from
Dan Carpenter).

These sanity checks mainly exist to trap maliciously corrupted
filesystems either through using a deliberately modified mksquashfs,
or where the user has deliberately chosen to generate uncompressed
metadata and then corrupted it.

Normally metadata in Squashfs filesystems is compressed, which means
corruption (either accidental or malicious) is detected when
trying to decompress the metadata.  So corrupted data does not normally
get as far as the code paths in question here.

Phillip Lougher (5):
  Squashfs: fix corruption check in get_dir_index_using_name()
  Squashfs: fix corruption checks in squashfs_lookup()
  Squashfs: fix corruption checks in squashfs_readdir()
  Squashfs: add corruption check in get_dir_index_using_offset()
  Squashfs: add corruption check for type in squashfs_readdir()

 fs/squashfs/dir.c         | 17 +++++++++++++----
 fs/squashfs/namei.c       |  7 +++----
 fs/squashfs/squashfs_fs.h |  5 ++++-
 3 files changed, 20 insertions(+), 9 deletions(-)

-- 
1.8.3.2


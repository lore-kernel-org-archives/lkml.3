Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab3KTBpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 20:45:50 -0500
Received: from mdfmta005.mxout.tbr.inty.net ([91.221.168.46]:36412 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753280Ab3KTBpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 20:45:49 -0500
From: Phillip Lougher <phillip@squashfs.org.uk>
To: linux-kernel@vger.kernel.org
Cc: minchan@kernel.org, Phillip Lougher <phillip@squashfs.org.uk>
Subject: [PATCH 0/7] Squashfs: performance enhancement patches
Date: Wed, 20 Nov 2013 01:45:19 +0000
Message-Id: <1384911927-11048-1-git-send-email-phillip@squashfs.org.uk>
X-Mailer: git-send-email 1.7.10.4
X-MDF-HostID: 8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the latest version of the performance improvement
patches.

Patch 3/7 is a V2 of the percpu patch following review.

If there are no further review comments/objections I
intend to get these merged.

Any objections, then please object now.

Thanks

Phillip

Minchan Kim (1):
      squashfs: Enhance parallel I/O

Phillip Lougher (6):
      Squashfs: Refactor decompressor interface and code
      Squashfs: Add multi-threaded decompression using percpu variables (V2)
      Squashfs: Generalise paging handling in the decompressors
      Squashfs: Restructure squashfs_readpage()
      Squashfs: Directly decompress into the page cache for file data
      Squashfs: Check stream is not NULL in decompressor_multi.c

 fs/squashfs/Kconfig                     |  72 ++++++++++++++++++++++++++++++++++++++++++++
 fs/squashfs/Makefile                    |   5 ++++
 fs/squashfs/block.c                     |  36 ++++++++++++----------
 fs/squashfs/cache.c                     |  28 +++++++++++++----
 fs/squashfs/decompressor.c              |  59 +++++++++++++++++++++++++-----------
 fs/squashfs/decompressor.h              |  24 ++++++---------
 fs/squashfs/decompressor_multi.c        | 198 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/squashfs/decompressor_multi_percpu.c |  97 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/squashfs/decompressor_single.c       |  85 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/squashfs/file.c                      | 142 +++++++++++++++++++++++++++++++++++++++++++-------------------------------------------
 fs/squashfs/file_cache.c                |  38 +++++++++++++++++++++++
 fs/squashfs/file_direct.c               | 173 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/squashfs/lzo_wrapper.c               |  47 +++++++++++++----------------
 fs/squashfs/page_actor.c                | 100 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/squashfs/page_actor.h                |  81 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/squashfs/squashfs.h                  |  20 +++++++++++--
 fs/squashfs/squashfs_fs_sb.h            |   4 +--
 fs/squashfs/super.c                     |  10 +++----
 fs/squashfs/xz_wrapper.c                | 105 ++++++++++++++++++++++++++++++++++++----------------------------
 fs/squashfs/zlib_wrapper.c              |  64 ++++++++++++++++-----------------------
 20 files changed, 1145 insertions(+), 243 deletions(-)
 create mode 100644 fs/squashfs/decompressor_multi.c
 create mode 100644 fs/squashfs/decompressor_multi_percpu.c
 create mode 100644 fs/squashfs/decompressor_single.c
 create mode 100644 fs/squashfs/file_cache.c
 create mode 100644 fs/squashfs/file_direct.c
 create mode 100644 fs/squashfs/page_actor.c
 create mode 100644 fs/squashfs/page_actor.h

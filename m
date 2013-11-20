Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab3KTShb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:37:31 -0500
Received: from mdfmta005.mxout.tbr.inty.net ([91.221.168.46]:37747 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751940Ab3KTSh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:37:28 -0500
Message-ID: <528D0164.7030402@lougher.demon.co.uk>
Date: Wed, 20 Nov 2013 18:37:24 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>
Subject: [GIT PULL] Squashfs updates for 3.13
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-MDF-HostID: 8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Squashfs updates ...

Thanks

Phillip

The following changes since commit 959f58544b7f20c92d5eb43d1232c96c15c01bfb:

   Linux 3.12-rc7 (2013-10-27 16:12:03 -0700)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-next.git tags/squashfs-updates

for you to fetch changes up to ed4f381ec15e5f11724cdbc68cffd2c22d1eaebd:

   Squashfs: Check stream is not NULL in decompressor_multi.c (2013-11-20 03:59:20 +0000)

----------------------------------------------------------------
These patches optionally improve the multi-threading peformance
of Squashfs by adding parallel decompression, and direct
decompression into the page cache, eliminating an intermediate
buffer (removing memcpy overhead and lock contention).

----------------------------------------------------------------
Minchan Kim (1):
       squashfs: Enhance parallel I/O

Phillip Lougher (6):
       Squashfs: Refactor decompressor interface and code
       Squashfs: add multi-threaded decompression using percpu variable
       Squashfs: Generalise paging handling in the decompressors
       Squashfs: Restructure squashfs_readpage()
       Squashfs: Directly decompress into the page cache for file data
       Squashfs: Check stream is not NULL in decompressor_multi.c

  fs/squashfs/Kconfig                     |  72 ++++++++++++
  fs/squashfs/Makefile                    |   5 +
  fs/squashfs/block.c                     |  36 +++---
  fs/squashfs/cache.c                     |  28 ++++-
  fs/squashfs/decompressor.c              |  59 +++++++---
  fs/squashfs/decompressor.h              |  24 ++--
  fs/squashfs/decompressor_multi.c        | 198 ++++++++++++++++++++++++++++++++
  fs/squashfs/decompressor_multi_percpu.c |  97 ++++++++++++++++
  fs/squashfs/decompressor_single.c       |  85 ++++++++++++++
  fs/squashfs/file.c                      | 142 ++++++++++++-----------
  fs/squashfs/file_cache.c                |  38 ++++++
  fs/squashfs/file_direct.c               | 173 ++++++++++++++++++++++++++++
  fs/squashfs/lzo_wrapper.c               |  47 ++++----
  fs/squashfs/page_actor.c                | 100 ++++++++++++++++
  fs/squashfs/page_actor.h                |  81 +++++++++++++
  fs/squashfs/squashfs.h                  |  20 +++-
  fs/squashfs/squashfs_fs_sb.h            |   4 +-
  fs/squashfs/super.c                     |  10 +-
  fs/squashfs/xz_wrapper.c                | 105 +++++++++--------
  fs/squashfs/zlib_wrapper.c              |  64 ++++-------
  20 files changed, 1145 insertions(+), 243 deletions(-)
  create mode 100644 fs/squashfs/decompressor_multi.c
  create mode 100644 fs/squashfs/decompressor_multi_percpu.c
  create mode 100644 fs/squashfs/decompressor_single.c
  create mode 100644 fs/squashfs/file_cache.c
  create mode 100644 fs/squashfs/file_direct.c
  create mode 100644 fs/squashfs/page_actor.c
  create mode 100644 fs/squashfs/page_actor.h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab3HRIlR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 04:41:17 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:62127 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab3HRIlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 04:41:15 -0400
From: Bob Liu <lliubbo@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, eternaleye@gmail.com, minchan@kernel.org,
        mgorman@suse.de, gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        axboe@kernel.dk, sjenning@linux.vnet.ibm.com, ngupta@vflare.org,
        semenzato@google.com, penberg@iki.fi, sonnyrao@google.com,
        smbarber@google.com, konrad.wilk@oracle.com, riel@redhat.com,
        kmpark@infradead.org, Bob Liu <bob.liu@oracle.com>
Subject: [PATCH 0/4] mm: merge zram into zswap
Date: Sun, 18 Aug 2013 16:40:45 +0800
Message-Id: <1376815249-6611-1-git-send-email-bob.liu@oracle.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both zswap and zram are used to compress anon pages in memory so as to reduce
swap io operation. The main different is that zswap uses zbud as its allocator
while zram uses zsmalloc. The other different is zram will create a block
device, the user need to mkswp and swapon it.

Minchan has areadly try to promote zram/zsmalloc into drivers/block/, but it may
cause increase maintenance headaches. Since the purpose of zswap and zram are
the same, this patch series try to merge them together as Mel suggested.
Dropped zram from staging and extended zswap with the same feature as zram.

zswap todo:
Improve the writeback of zswap pool pages!

Bob Liu (4):
  drivers: staging: drop zram and zsmalloc
  mm: promote zsmalloc to mm/
  mm: zswap: add supporting for zsmalloc
  mm: zswap: create a pseudo device /dev/zram0

 drivers/staging/Kconfig                  |    4 -
 drivers/staging/Makefile                 |    2 -
 drivers/staging/zram/Kconfig             |   25 -
 drivers/staging/zram/Makefile            |    3 -
 drivers/staging/zram/zram.txt            |   77 ---
 drivers/staging/zram/zram_drv.c          |  925 --------------------------
 drivers/staging/zram/zram_drv.h          |  115 ----
 drivers/staging/zsmalloc/Kconfig         |   10 -
 drivers/staging/zsmalloc/Makefile        |    3 -
 drivers/staging/zsmalloc/zsmalloc-main.c | 1063 -----------------------------
 drivers/staging/zsmalloc/zsmalloc.h      |   43 --
 include/linux/zsmalloc.h                 |   44 ++
 mm/Kconfig                               |   51 +-
 mm/Makefile                              |    1 +
 mm/zsmalloc.c                            | 1068 ++++++++++++++++++++++++++++++
 mm/zswap.c                               |  269 +++++++-
 16 files changed, 1418 insertions(+), 2285 deletions(-)
 delete mode 100644 drivers/staging/zram/Kconfig
 delete mode 100644 drivers/staging/zram/Makefile
 delete mode 100644 drivers/staging/zram/zram.txt
 delete mode 100644 drivers/staging/zram/zram_drv.c
 delete mode 100644 drivers/staging/zram/zram_drv.h
 delete mode 100644 drivers/staging/zsmalloc/Kconfig
 delete mode 100644 drivers/staging/zsmalloc/Makefile
 delete mode 100644 drivers/staging/zsmalloc/zsmalloc-main.c
 delete mode 100644 drivers/staging/zsmalloc/zsmalloc.h
 create mode 100644 include/linux/zsmalloc.h
 create mode 100644 mm/zsmalloc.c

-- 
1.7.10.4


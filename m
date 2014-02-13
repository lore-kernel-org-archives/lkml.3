Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaBMRqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:46:52 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:64373 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbaBMRqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:46:49 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv5 0/4] add compressing abstraction and multi stream support
Date: Thu, 13 Feb 2014 20:43:18 +0300
Message-Id: <1392313402-5728-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.rc3.260.g4cf525c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces zcomp compression backend abstraction
adding ability to support compression algorithms other than LZO;
support for multi compression streams, making parallel compressions
possible.

Diff from v4 (reviewed by Minchan Kim):
-- renamed zcomp buffer_lock; removed src len and dst len from
   compress() and decompress(); not using term `buffer' and
   `workmem' in code and documentation; define compress() and
   decompress() functions for LZO backend; not using goto's;
   do not put idle zcomp_strm to idle list tail.

Diff from v3:
-- renamed compression backend and working memory structs as requested
   by Minchan Kim; fixed several issues noted by Minchan Kim.

Sergey Senozhatsky (4):
  zram: introduce compressing backend abstraction
  zram: use zcomp compressing backends
  zram: zcomp support multi compressing streams
  zram: document max_comp_streams

 Documentation/ABI/testing/sysfs-block-zram |   9 +-
 Documentation/blockdev/zram.txt            |  20 +++-
 drivers/block/zram/Makefile                |   2 +-
 drivers/block/zram/zcomp.c                 | 155 +++++++++++++++++++++++++++++
 drivers/block/zram/zcomp.h                 |  56 +++++++++++
 drivers/block/zram/zcomp_lzo.c             |  48 +++++++++
 drivers/block/zram/zram_drv.c              | 102 ++++++++++++-------
 drivers/block/zram/zram_drv.h              |  10 +-
 8 files changed, 355 insertions(+), 47 deletions(-)
 create mode 100644 drivers/block/zram/zcomp.c
 create mode 100644 drivers/block/zram/zcomp.h
 create mode 100644 drivers/block/zram/zcomp_lzo.c

-- 
1.9.0.rc3.260.g4cf525c


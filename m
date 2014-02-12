Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbaBLTnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:43:17 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:33631 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbaBLTnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:43:05 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv4 0/4] add compressing abstraction and multi stream support
Date: Wed, 12 Feb 2014 22:39:31 +0300
Message-Id: <1392233976-26473-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.rc3.256.g4af3ebd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces zcomp compression backend abstraction
adding ability to support compression algorithms other than LZO;
support for multi compression streams, making parallel compressions
possible.

Diff from v3:
-- renamed compression backend and working memory structs as requested
   by Minchan Kim; fixed several issues noted by Minchan Kim.

Sergey Senozhatsky (4):
  zram: introduce compressing backend abstraction
  zram: use zcomp compressing backends
  zram: support multi compressing buffers
  zram: document max_comp_streams

 Documentation/ABI/testing/sysfs-block-zram |   9 +-
 Documentation/blockdev/zram.txt            |  21 +++-
 drivers/block/zram/Makefile                |   2 +-
 drivers/block/zram/zcomp.c                 | 156 +++++++++++++++++++++++++++++
 drivers/block/zram/zcomp.h                 |  58 +++++++++++
 drivers/block/zram/zcomp_lzo.c             |  33 ++++++
 drivers/block/zram/zram_drv.c              | 102 ++++++++++++-------
 drivers/block/zram/zram_drv.h              |  10 +-
 8 files changed, 345 insertions(+), 46 deletions(-)
 create mode 100644 drivers/block/zram/zcomp.c
 create mode 100644 drivers/block/zram/zcomp.h
 create mode 100644 drivers/block/zram/zcomp_lzo.c

-- 
1.9.0.rc3.256.g4af3ebd


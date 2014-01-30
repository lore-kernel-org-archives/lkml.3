Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbaA3Tbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 14:31:38 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:42853 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbaA3Tbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 14:31:36 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv2 0/2] add compression backend abstraction
Date: Thu, 30 Jan 2014 22:28:06 +0300
Message-Id: <1391110088-14830-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.rc1.183.g614c158
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add abstraction layer (zram_comp) to avoid direct LZO
calls and use a common compression backend interface instead. Patchset
introduces LZ4 support and new device attribute to switch used
compression algorithm.

Sergey Senozhatsky (2):
  zram: introduce compressing backend abstraction
  zram: use zram_comp compressing backends

 drivers/block/zram/Kconfig     |  20 +++-
 drivers/block/zram/Makefile    |   6 +-
 drivers/block/zram/zcomp_lz4.c |  49 ++++++++++
 drivers/block/zram/zcomp_lz4.h |  18 ++++
 drivers/block/zram/zcomp_lzo.c |  49 ++++++++++
 drivers/block/zram/zcomp_lzo.h |  18 ++++
 drivers/block/zram/zram_comp.c | 204 +++++++++++++++++++++++++++++++++++++++++
 drivers/block/zram/zram_comp.h |  64 +++++++++++++
 drivers/block/zram/zram_drv.c  |  96 ++++++++++++-------
 drivers/block/zram/zram_drv.h  |   8 +-
 10 files changed, 492 insertions(+), 40 deletions(-)
 create mode 100644 drivers/block/zram/zcomp_lz4.c
 create mode 100644 drivers/block/zram/zcomp_lz4.h
 create mode 100644 drivers/block/zram/zcomp_lzo.c
 create mode 100644 drivers/block/zram/zcomp_lzo.h
 create mode 100644 drivers/block/zram/zram_comp.c
 create mode 100644 drivers/block/zram/zram_comp.h

-- 
1.9.rc1.183.g614c158


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaBKWYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 17:24:36 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:50290 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaBKWYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 17:24:35 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv3 0/4] add compression backend abstraction
Date: Wed, 12 Feb 2014 01:21:02 +0300
Message-Id: <1392157266-13488-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.rc3.244.g3497008
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces zram_comp compression backend abstraction
adding ability to support compression algorithms other than LZO,
and support for multi buffers, making parallel compressions possible.

Sergey Senozhatsky (4):
  zram: introduce compressing backend abstraction
  zram: use zram_comp compressing backends
  zram: support multi compressing buffers
  zram: document max_buffers

 Documentation/ABI/testing/sysfs-block-zram |   9 +-
 Documentation/blockdev/zram.txt            |  21 +++-
 drivers/block/zram/Makefile                |   2 +-
 drivers/block/zram/zcomp_lzo.c             |  33 +++++++
 drivers/block/zram/zram_comp.c             | 150 +++++++++++++++++++++++++++++
 drivers/block/zram/zram_comp.h             |  58 +++++++++++
 drivers/block/zram/zram_drv.c              | 102 +++++++++++++-------
 drivers/block/zram/zram_drv.h              |  10 +-
 8 files changed, 339 insertions(+), 46 deletions(-)
 create mode 100644 drivers/block/zram/zcomp_lzo.c
 create mode 100644 drivers/block/zram/zram_comp.c
 create mode 100644 drivers/block/zram/zram_comp.h

-- 
1.9.0.rc3.244.g3497008


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134AbaKMMz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 07:55:57 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40411 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932603AbaKMMzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 07:55:54 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <chris@printf.net>, <ulf.hansson@linaro.org>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <afenkart@gmail.com>, <kishon@ti.com>
Subject: [RFC PATCH 0/3] DRA72: MMC HS200 support
Date: Thu, 13 Nov 2014 18:25:21 +0530
Message-ID: <1415883324-19591-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added HS200 to improve EMMC throughput for dra72.

With HS200
==============
Read throughput
./dd if=/dev/mmcblk0 of=/dev/null bs=1M count=100 oflag=sync
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 1.46028 s, 71.8 MB/s

Write throughput
root@dra7xx-evm:/# ./dd if=/dev/zero of=/dev/mmcblk0 bs=1M count=100 oflag=sync
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 9.34884 s, 11.2 MB/s


WithOUT HS200
==============
Read throughput
./dd if=/dev/mmcblk0 of=/dev/null bs=1M count=100 oflag=sync
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 2.6423 s, 39.7 MB/s

Write throughput
./dd if=/dev/zero of=/dev/mmcblk0 bs=1M count=100 oflag=sync
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 9.3556 s, 11.2 MB/s

Balaji T K (1):
  mmc: omap_hsmmc: add tuning support

Kishon Vijay Abraham I (1):
  ARM: dts: dra72-evm: Set the max-frequency to 192MHz

Viswanath Puttagunta (1):
  mmc: omap_hsmmc: set host capabilities by reading MMCHS_CAPA2
    register

 arch/arm/boot/dts/dra72-evm.dts |    1 +
 drivers/mmc/host/omap_hsmmc.c   |  342 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 341 insertions(+), 2 deletions(-)

-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbbAWQI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:08:58 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:50199 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367AbbAWQIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:08:54 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mark Brown <broonie@kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 00/18] spi/xilinx: Speed-up
Date: Fri, 23 Jan 2015 17:08:32 +0100
Message-Id: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches has been developed after using the core to access a spi
nor flash. The initial performance was not as desired. The following changes
have been done.

-This series of patches add driver support for hardware implemented modes:
LSB_FIRS, LOOP and CS_HIGH.

-There is support for irq less operations.

-The buffer size of the core is detected at probe time, speeding up the
operations.

-Code has been simplify and cleaned

This are the results, before and after the patchet

Original
root@qt5022:~# dd if=/dev/mtd0 of=/dev/null
16384+0 records in
16384+0 records out
8388608 bytes (8.4 MB) copied, 117.985 s, 71.1 kB/s

 37:        107      82853  Xilinx INTC Level   1  b0010000.spi-flash

After patchset (irq):
root@qt5022:~# dd if=/dev/mtd0 of=/dev/null
16384+0 records in
16384+0 records out
8388608 bytes (8.4 MB) copied, 49.009 s, 171 kB/s

After patchset (irq):
root@qt5022:~# dd if=/dev/mtd0 of=/dev/null
16384+0 records in
16384+0 records out
8388608 bytes (8.4 MB) copied, 41.2526 s, 203 kB/s

IRQS: ZERO

This set of patches supersedes the previous patchet with only LSB_FIRST and LOOP

Ricardo Ribalda Delgado (18):
  spi/xilinx: Support for spi mode LSB_FIRST
  spi/xilinx: Support for spi mode LOOP
  spi/xilinx: Simplify data read from the Rx FIFO
  spi-xilinx: Simplify spi_fill_tx_fifo
  spi/xilinx: Leave the IRQ always enabled.
  spi/xilinx: Code cleanup
  spi/xilinx: Use cached value of register
  spi/xilinx: Support cores with no interrupt
  spi/xilinx: Do not inhibit transmission in polling mode
  spi/xilinx: Support for spi mode CS_HIGH
  spi/xilinx: Remove rx_fn and tx_fn pointer
  spi/xilinx: Make spi_tx and spi_rx simmetric
  spi/xilinx: Convert remainding_bytes in remaining words
  spi/xilinx: Convert bits_per_word in bytes_per_word
  spi/xilinx: Remove iowrite/ioread wrappers
  spi/xilinx: Reset core before buffer_size detection
  spi/xilinx: Remove remaining_words driver data variable
  spi/xilinx: Check number of slaves range

 drivers/spi/spi-xilinx.c | 306 ++++++++++++++++++++++-------------------------
 1 file changed, 146 insertions(+), 160 deletions(-)

-- 
2.1.4


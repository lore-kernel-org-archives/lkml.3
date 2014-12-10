Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbaLJLtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:49:52 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:58976 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbaLJLtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:49:50 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-d4-5488335d7fc8
From: Robert Baldyga <r.baldyga@samsung.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, akpm@linux-foundation.org, kgene.kim@samsung.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        l.czerwinski@samsung.com, s.nawrocki@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 0/6] serial: samsung: add DMA support
Date: Wed, 10 Dec 2014 12:49:21 +0100
Message-id: <1418212167-28992-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t9jQd1Y444Qg5PtChZz1q9hs2hevJ7N
	4vPvXawWvQuuslmcbXrDbvFr2iQ2i8u75rBZnFncy26x9shddosHh3eyWxx+087qwO1xYsZv
	Fo/9c9ewe/RtWcXocWbBEXaPz5vkAlijuGxSUnMyy1KL9O0SuDJm75vFXLCDp+LcxwOMDYyN
	XF2MnBwSAiYS71/NYYOwxSQu3FsPZHNxCAlMZ5R4d3UBI4TTziRx//UXdpAqNgEdiS3fJzCC
	2CICchJPbv9hBiliFpjKJLHp+iQmkISwgKnE5C13wRpYBFQl3s1oYwaxeQVcJaY93coOsU5O
	4uSxyawTGLkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAgOqGfSOxhXNVgcYhTgYFTi
	4Q243B4ixJpYVlyZe4hRgoNZSYT3jWRHiBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFeJfu2ECGB
	9MSS1OzU1ILUIpgsEwenVAMjQ6AwV97xHYxuG1U3l//4dUphS8X8OplFMpcffVrV8+fb3KNS
	T02XScXP1RDilyjbP8Xf8FzUt7srTNK5F5orvHTUmsF+Z3KK1CHDv/l93BrMvXrFuVN0u7/k
	N3t5vHJ/eKtxqehl08ATlnc7Xc7NurTV//ZzAbcstkS7oE2/XjYdfPZ0w7F9SizFGYmGWsxF
	xYkA4S3aXSQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch introduces DMA mode in samsung serial driver. It reduces
number of interrupts and CPU usage while sending large data blocks.

For TX transfers DMA mode is used when number of bytes to send it larger
than TX FIFO size, for smaller transfers PIO mode is used.

For RX transfers DMA mode is used when number of bytes in RX FIFO is
larger than threshold level. If it's not, we obtain RX timeout interrupt
and we receive data in PIO mode.

DMA mode is enabled when "dmas" property is defined in device-tree node
of serial port. Otherwise PIO mode is used.

To have this working, proper residue handling and DMA_PAUSE support in
DMAC driver are necessary. At many samsung platforms DMAC is pl330, which
does not have those features in mainline driver yet, so if you would
like to test series, my patches for pl330 driver are needed. You can
find them here:
https://lkml.org/lkml/2014/12/10/156

Entire series is based on previous work of Sylwester Nawrocki and
Lukasz Czerwinski.

Best regards,
Robert Baldyga

Robert Baldyga (6):
  serial: samsung: add struct s3c24xx_uart_dma
  serial: samsung: alloc dma stucture in ourport
  serial: s3c: add missing register definitions
  serial: samsung: add dma reqest/release functions
  serial: samsung: add DMA support for TX
  serial: samsung: add DMA support for RX

 drivers/tty/serial/samsung.c | 582 +++++++++++++++++++++++++++++++++++++++++--
 drivers/tty/serial/samsung.h |  42 ++++
 include/linux/serial_s3c.h   |  28 +++
 3 files changed, 634 insertions(+), 18 deletions(-)

-- 
1.9.1


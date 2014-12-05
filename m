Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaLEI0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:26:12 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:12691 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbaLEI0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:26:10 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-99-54816c20321e
From: Robert Baldyga <r.baldyga@samsung.com>
To: vinod.koul@intel.com
Cc: dan.j.williams@intel.com, lars@metafoo.de, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        l.czerwinski@samsung.com, kyungmin.park@samsung.com,
        k.kozlowski@samsung.com, padma.kvr@gmail.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 0/2] dma: pl330: improve status checking
Date: Fri, 05 Dec 2014 09:25:53 +0100
Message-id: <1417767955-5480-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e+xgK5CTmOIwbElvBbTp15gtFg99S+r
	xesXhhZnm96wW/yaNonNYsnk+awWl3fNYbNYe+Quu0X7sjmsFg8O72S3eNm3n8WB22PnrLvs
	Hov3vGTyWPLmEKtH35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVwZax9+oOx4DRHxYnGLuYGxg72
	LkZODgkBE4nmv4+gbDGJC/fWs3UxcnEICSxilLg/r4MJwmlnkrhz7CUbSBWbgI7Elu8TGEFs
	EQEJie3P+thBipgFJjJJrO2/CFTEwSEsYC0xebIZSA2LgKrEjBWXWUFsXgEXie/rupghtslJ
	nDw2mXUCI/cCRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHB9Ex6B+OqBotDjAIcjEo8
	vCskGkOEWBPLiitzDzFKcDArifAWKgKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8964mRsiJJCe
	WJKanZpakFoEk2Xi4JRqYLS6ot4j6rHeZYcpl/My3VifN+mTz8nGbiqex9PZ5nBzUsay9RPa
	zk7zFZ5ukeIYOLmm+KuG63vvWnXvL/MiekP8lizOb7744Wu3/bbQiiOXM75zNasFT0s7cjtU
	4ZT0hw11J7at0JrQe/Hvo22LgytnFPBkTZxxqH/igcZH+5OS/ZZsDV0mrqLEUpyRaKjFXFSc
	CAAe8PklIgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series allows to check DMA transfer residue (number of bytes left
to send/receive) by modifying pl330_tx_status() function, when struct
dma_tx_state is filled with needed data. It also introduces DMA_PAUSE
feature, which allows to halt DMA transfer before termination and read
residue without risk of data loss.

This features are needed for proper implementation of DMA transfers,
particulary for serial drivers when transfer sizes are unknown and
requests on DMA channels are terminated before transfer completion
very ofter (it's becouse we terminate then in timeout interrupt to
avoid latency which is usually undesirable).

Best regards,
Robert Baldyga

Changelog:

v2:
- add pm_runtime support
- make it working for multi-segment transfers
- some cleanups

v1: https://lkml.org/lkml/2014/11/25/554

Robert Baldyga (2):
  dma: pl330: improve pl330_tx_status() function
  dma: pl330: add DMA_PAUSE feature

 drivers/dma/pl330.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 85 insertions(+), 2 deletions(-)

-- 
1.9.1


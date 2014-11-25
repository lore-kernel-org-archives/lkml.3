Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbaKYM0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:26:04 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:47043 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaKYM0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:26:01 -0500
X-AuditID: cbfee61a-f79c06d000004e71-d2-5474755623d1
From: Robert Baldyga <r.baldyga@samsung.com>
To: vinod.koul@intel.com
Cc: dan.j.williams@intel.com, ars@metafoo.de, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        l.czerwinski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 0/2] dma: pl330: improve status checking
Date: Tue, 25 Nov 2014 13:25:44 +0100
Message-id: <1416918346-2442-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDJMWRmVeSWpSXmKPExsVy+t9jQd2w0pIQg2s7TS0uHOhktJg+9QKj
	xeqpf1ktfk2bxGZxedccNou1R+6yWzw4vJPd4mXffhYHDo/Fe14yeSx5c4jVo2/LKkaPz5vk
	AliiuGxSUnMyy1KL9O0SuDI+TDvHXLCevWLi53+sDYxdbF2MnBwSAiYS248cZ4awxSQu3FsP
	FOfiEBKYzihx+u8FZginnUni85pfTCBVbAI6Elu+T2AEsUUEJCS2P+tjByliFjjKKDF97gWw
	scICFhIXl89k6WLk4GARUJXYPZEDJMwr4CJxaPYGVohtchInj01mncDIvYCRYRWjaGpBckFx
	UnquoV5xYm5xaV66XnJ+7iZGcJg8k9rBuLLB4hCjAAejEg9vx9niECHWxLLiytxDjBIczEoi
	vE+SS0KEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8964mRsiJJCeWJKanZpakFoEk2Xi4JRqYGSX
	2r2CP6XRhqlJLSbzy4602RaPc6YWy75U91u76Iqmjl7TXOV3ERoFub/fTX92qf+GoFTPq9ke
	z4S2c0kd0dyYwLb3+tvj1swPKv0vcoXfuPX3w4GNR6uP17v0PAqa25yw4dcNxqkp9Wssgv1E
	3U1nX71+5f7iW7eYm8RVqgLkLZrioxdL2SixFGckGmoxFxUnAgBSbcyhDwIAAA==
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

Robert Baldyga (2):
  dma: pl330: improve pl330_tx_status() function
  dma: pl330: add DMA_PAUSE feature

 drivers/dma/pl330.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 73 insertions(+), 1 deletion(-)

-- 
1.9.1


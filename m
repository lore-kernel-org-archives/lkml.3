Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbaLJKzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:55:53 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:38392 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaLJKzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:55:51 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-b9-548826b45c23
From: Robert Baldyga <r.baldyga@samsung.com>
To: vinod.koul@intel.com
Cc: dan.j.williams@intel.com, lars@metafoo.de, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        l.czerwinski@samsung.com, padma.kvr@gmail.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 0/2] dma: pl330: improve status checking
Date: Wed, 10 Dec 2014 11:55:16 +0100
Message-id: <1418208918-28127-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e+xoO4WtY4Qg99/JS2mT73AaLF66l9W
	i9cvDC3ONr1ht/g1bRKbxZLJ81ktLu+aw2ax9shddov2ZXNYLR4c3slu8bJvP4sDt8fOWXfZ
	PRbvecnkseTNIVaPvi2rGD0+b5ILYI3isklJzcksSy3St0vgyuhePY+9YDpnxeWrN1gbGE+x
	dzFyckgImEhcWLOLCcIWk7hwbz1bFyMXh5DAdEaJh3OmgBUJCbQzSaz4LQtiswnoSGz5PoER
	xBYRkJDY/qyPHaSBWWAik0T//ktA3RwcwgLWErM28oPUsAioSuyd+p8VxOYVcJU48n0+C8Qy
	OYmTxyazTmDkXsDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOJSeSe9gXNVgcYhRgINR
	iYc34HJ7iBBrYllxZe4hRgkOZiUR3jeSHSFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZXs20KE
	BNITS1KzU1MLUotgskwcnFINjAvmNizkPyrC6P5i3aegb/vt4r7wTbSUUlo0WXNCqfLCvHkO
	BwyS0iecTLF2sFBK061fvaAt9cC0z0UTj1/bFuFh1qrH55vZz+69Y+kHDRbrzwW2BvMcWeYG
	9z3Mv8JhILlG2KK1+5ZVYo9t+p2SA9NqD9qbLvNJrHM/+164cutlI8V3FlqvlViKMxINtZiL
	ihMB2tg3BiECAAA=
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

v3:
- remove double pm_runtime_put()

v2: https://lkml.org/lkml/2014/12/5/94
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


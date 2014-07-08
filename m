Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbaGHKrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 06:47:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59270 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbaGHKrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 06:47:14 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>, <vinod.koul@intel.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <dmaengine@vger.kernel.org>
Subject: [PATCH 0/3] ARM/dma: edma: Serve cyclic clients via high priority queue
Date: Tue, 8 Jul 2014 13:46:35 +0300
Message-ID: <1404816398-12338-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It is preferred that audio is served with the highest priority queue in order to
avoid delays in data transfer between memory and audio IP.

The following series will add an API to arch code to assign a channel to a given
queue.
The default queue is changed from 0 (highest priority) to lowest priority.
In the dmaengine driver we move the cyclic channel to queue0 (highest priority)
and move it back to default queue when the channel is terminated.

Regards,
Peter
---
Peter Ujfalusi (3):
  ARM: edma: Set default queue to lowest priority
  ARM: edma: Add edma_assign_channel_eventq() to move channel to a give
    queue
  dma: edma: Serve cyclic (audio) channels with high priority queue

 arch/arm/common/edma.c             | 31 ++++++++++++++++++++++++++++++-
 drivers/dma/edma.c                 |  8 ++++++++
 include/linux/platform_data/edma.h |  2 ++
 3 files changed, 40 insertions(+), 1 deletion(-)

-- 
2.0.0


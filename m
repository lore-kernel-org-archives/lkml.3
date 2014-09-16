Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbaIPTqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:46:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52422 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468AbaIPTqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:46:13 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH v3 0/2] dmaengine: omap-dma: Fix cyclic suspend/resume
Date: Tue, 16 Sep 2014 22:45:55 +0300
Message-ID: <1410896757-3848-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Changes since v2:
- fix typo in patch two
- Acked-by added from Russell

When the audio is paused/resumed (application paused the sream or board suspend)
the audio was only playing back one period worth of data and then stops because
the omap_dam_stop() clears the link configuration and it is not restored in
start.

Also add memory barrier call to resume path since this could happen right after
coming out from suspend.

Regards,
Peter
---
Peter Ujfalusi (2):
  dmaengine: omap-dma: Add memory barrier to dma_resume path
  dmaengine: omap-dma: Restore the CLINK_CTRL in resume path

 drivers/dma/omap-dma.c | 5 +++++
 1 file changed, 5 insertions(+)

-- 
2.1.0


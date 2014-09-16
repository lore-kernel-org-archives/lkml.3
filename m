Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbaIPNyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:54:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56021 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbaIPNyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 09:54:04 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH v2 0/2] dmaengine: omap-dma: Fix cyclic suspend/resume
Date: Tue, 16 Sep 2014 16:53:47 +0300
Message-ID: <1410875629-1540-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

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


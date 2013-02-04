Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab3BDTq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:46:26 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:45832 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab3BDTqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:46:24 -0500
From: Matt Porter <mporter@ti.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: [PATCH v3 0/3] dmaengine: add slave sg transfer capabilities api
Date: Mon,  4 Feb 2013 14:47:01 -0500
Message-Id: <1360007224-21735-1-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v2:
	- Change to a separate slave sg specific api. Drop the
	  generic per-channel capabilities api that is not used.

Changes since v1:
	- Use the existing dma_transaction_type enums instead of
	  adding the mostly duplicated dmaengine_apis enums

This series adds a new dmaengine api, dma_get_slave_sg_caps(), which
may be used by a client driver to get slave SG transfer capabilities
for a particular channel. At this time, these include the max number
of segments and max length of a segment that a channel can handle for
a SG transfer.

Along with the API implementation, this series implements the backend
device_slave_sg_caps() in the EDMA DMA Engine driver and converts the
davinci_mmc driver to use dma_get_slave_sg_caps() to replace hardcoded
limits.

This is tested on the AM1808-EVM.

Matt Porter (3):
  dmaengine: add dma_get_slave_sg_caps()
  dma: edma: add device_slave_sg_caps() support
  mmc: davinci: get SG segment limits with dma_get_slave_sg_caps()

 drivers/dma/edma.c                        |   17 ++++++++++++
 drivers/mmc/host/davinci_mmc.c            |   37 ++++++++------------------
 include/linux/dmaengine.h                 |   40 +++++++++++++++++++++++++++++
 include/linux/platform_data/mmc-davinci.h |    3 ---
 4 files changed, 67 insertions(+), 30 deletions(-)

-- 
1.7.9.5


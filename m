Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaJKQUw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:20:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:29315 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbaJKQUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:20:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,699,1406617200"; 
   d="scan'208";a="603887813"
From: Vinod Koul <vinod.koul@intel.com>
To: dmaengine@vger.kernel.org
Cc: Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 0/6] dmaengine: remove FSLDMA_EXTERNAL_START
Date: Sat, 11 Oct 2014 21:16:42 +0530
Message-Id: <1413042408-28491-1-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FSLDMA_EXTERNAL_START is one of the custom methods in device_control. Since
we are planning to deprecate device_control, we should move this to an API.

This serries adds the fsl_dma_external_start() API for users and also
converts the users.

I would like this to be merged thru dmanegine tree due to new dependency.

Vinod Koul (6):
  dmaengine: add dmaengine_prep_dma_sg() helper
  dmaengine: freescale: add and export fsl_dma_external_start()
  carma-fpga: use dmaengine_xxx() API
  carma-fpga: move to fsl_dma_external_start()
  dmaengine: freescale: remove FSLDMA_EXTERNAL_START control method
  dmaengine: remove FSLDMA_EXTERNAL_START

 drivers/dma/fsldma.c                    |   25 +++++++++++++++----------
 drivers/misc/carma/carma-fpga-program.c |   12 ++++++------
 include/linux/dmaengine.h               |   13 ++++++++++---
 include/linux/fsldma.h                  |   13 +++++++++++++
 4 files changed, 44 insertions(+), 19 deletions(-)
 create mode 100644 include/linux/fsldma.h


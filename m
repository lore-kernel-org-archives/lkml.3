Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbaI0I5c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 04:57:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38677 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752865AbaI0I4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 04:56:53 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/9] dmaengine: Implement generic slave capabilities retrieval
Date: Sat, 27 Sep 2014 10:54:36 +0200
Message-Id: <1411808085-27792-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As we discussed a couple of weeks ago, this is a first attempt at
creating a generic behaviour for slave capabilities retrieval so that
generic layers using dmaengine can actually rely on that.

That has been done mostly through two steps: by moving out the
sub-commands of the device_control callback, so that the dmaengine
core can then infer from that wether a sub-command is implemented, and
then by moving the slave properties, such as the supported buswidth,
to the structure dma_device itself.

Comments are as usual appreciated!

Thanks,
Maxime

Maxime Ripard (9):
  dmaengine: Make the destination abbreviation coherent
  dmaengine: Make channel allocation callbacks optional
  dmaengine: Introduce a device_config callback
  dmaengine: split out pause/resume operations from device_control
  dmaengine: Add device_terminate_all callback
  dmaengine: Create a generic dma_slave_caps callback
  dmaengine: Move slave caps to dma_device
  dmaengine: Mark device_control as deprecated
  dmaengine: sun6i: Convert to generic slave_caps

 drivers/dma/bcm2835-dma.c |   2 +-
 drivers/dma/dmaengine.c   |   4 --
 drivers/dma/edma.c        |   2 +-
 drivers/dma/fsl-edma.c    |   2 +-
 drivers/dma/omap-dma.c    |   2 +-
 drivers/dma/pl330.c       |   2 +-
 drivers/dma/sirf-dma.c    |   2 +-
 drivers/dma/sun6i-dma.c   | 158 +++++++++++++++++++++++++---------------------
 include/linux/dmaengine.h |  81 +++++++++++++++++++-----
 9 files changed, 158 insertions(+), 97 deletions(-)

-- 
2.1.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab3CEVNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 16:13:01 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:65115 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428Ab3CEVM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 16:12:59 -0500
From: Matt Porter <mporter@ti.com>
To: Balaji T K <balajitk@ti.com>, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Jon Hunter <jon-hunter@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v2 0/3] omap_hsmmc DT DMA Client support
Date: Tue,  5 Mar 2013 16:13:21 -0500
Message-Id: <1362518004-7083-1-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
	- rebase to 3.9-rc1, previous dependencies upstream

This series adds DT DMA Engine Client support to the omap_hsmmc.
It leverages the generic DMA OF helpers in -next and the
dma_request_slave_channel_compat() wrapper introduced in the
AM33XX DMA Engine series to support DMA in omap_hsmmc on platforms
booting via DT. These platforms include omap2/3/4/5 and am33xx.

These patches were split out from the v5 version of the AM33XX DMA
series and split from the EDMA-specific omap_hsmmc changes.

Matt Porter (2):
  mmc: omap_hsmmc: convert to dma_request_slave_channel_compat()
  mmc: omap_hsmmc: add generic DMA request support to the DT binding

Santosh Shilimkar (1):
  mmc: omap_hsmmc: Skip platform_get_resource_byname() for dt case

 .../devicetree/bindings/mmc/ti-omap-hsmmc.txt      |   26 +++++++++++++-
 drivers/mmc/host/omap_hsmmc.c                      |   38 ++++++++++++--------
 2 files changed, 48 insertions(+), 16 deletions(-)

-- 
1.7.9.5


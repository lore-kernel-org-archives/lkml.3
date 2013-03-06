Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab3CFOLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:11:43 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:32857 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408Ab3CFOLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:11:42 -0500
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
Subject: [PATCH v3 0/2] omap_hsmmc DT DMA Client support
Date: Wed,  6 Mar 2013 09:12:06 -0500
Message-Id: <1362579128-5312-1-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v2:
	- dropped skip platform_get_resource_byname() patch
Changes since v1:
	- rebase to 3.9-rc1, previous dependencies upstream

This series adds DT DMA Engine Client support to the omap_hsmmc.
It leverages the generic DMA OF helpers and the
dma_request_slave_channel_compat() wrapper to support DMA in
omap_hsmmc on platforms booting via DT. These platforms include
omap2/3/4/5 and am33xx.

These patches were split out from the v5 version of the AM33XX DMA
series and split from the EDMA-specific omap_hsmmc changes.

Matt Porter (2):
  mmc: omap_hsmmc: convert to dma_request_slave_channel_compat()
  mmc: omap_hsmmc: add generic DMA request support to the DT binding

 .../devicetree/bindings/mmc/ti-omap-hsmmc.txt      |   26 +++++++++++++++++++-
 drivers/mmc/host/omap_hsmmc.c                      |   10 ++++++--
 2 files changed, 33 insertions(+), 3 deletions(-)

-- 
1.7.9.5


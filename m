Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306Ab3GRQrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:47:49 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35101 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759216Ab3GRQrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:47:45 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Balaji TK <balajitk@ti.com>,
        Gururaja Hebbar <gururaja.hebbar@ti.com>, Chris Ball <cjb@laptop.org>
CC: Jason Kridner <jkridner@beagleboard.org>,
        Mark Jackson <mpfj-list@newflow.co.uk>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/3] Pending dmaengine patches
Date: Thu, 18 Jul 2013 11:46:38 -0500
Message-ID: <1374166001-31340-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've reworked Matt's dmaegine sg_limits series addressing review comments at [1].

Currently MMC on AM33xx requires EDMA which was posted and accepted, following
it is a series that are fixes that have to go in for it to work correctly.
Without this series, DMA fails on MMC resulting in I/O errors.

A subsequent MMC DT patch for AM33xx is also on hold [2] for the same reason.

Tested on AM335x (Beaglebone Rev A5A).

[1] http://linux.davincidsp.com/pipermail/davinci-linux-open-source/2013-March/026658.html
[2] http://lkml.indiana.edu/hypermail/linux/kernel/1306.3/03766.html

Matt Porter (3):
  dmaengine: add dma_get_slave_sg_limits()
  mmc: omap_hsmmc: set max_segs based on dma engine limits
  dma: edma: add device_slave_sg_limits() support

 drivers/dma/edma.c            |   14 +++++++++++++
 drivers/mmc/host/omap_hsmmc.c |    9 +++++++++
 include/linux/dmaengine.h     |   45 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+)

-- 
1.7.9.5


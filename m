Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab3FELkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:40:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37975 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342Ab3FELkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:40:20 -0400
From: Illia Smyrnov <illia.smyrnov@ti.com>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mark Brown <broonie@kernel.org>
CC: Illia Smyrnov <illia.smyrnov@ti.com>, Daniel Mack <zonque@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>
Subject: [PATCH 0/2] spi: omap2-mcspi: add FIFO buffer support
Date: Wed, 5 Jun 2013 14:39:56 +0300
Message-ID: <1370432398-7796-1-git-send-email-illia.smyrnov@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches introduce FIFO support for TI OMAP4/OMAP5 MCSPI controller.
Using FIFO unload the DMA and improve data throughput. On Blaze (OMAP 4460) 
ethernet throughput with 2 bytes MCSPI FIFO buffer enabled was increased 
from 7.0877 Mbps to 7.9200 Mbps. The FIFO implementation sanity test on 
OMAP5 Panda board also has been done.

The FIFO buffer can be used with some limitations, so if enabled, it will be
set up only for suitable SPI transfers:
* FIFO depth size defined as a multiple of the SPI word length;
* transfer's data size is a multiple of FIFO depth;
* transfer's words count less or equal 65535.

To store FIFO parameters in DT modified Matthias Brugger patch has been used
(see the discussion at https://patchwork.kernel.org/patch/2333911/)

Illia Smyrnov (1):
  spi: omap2-mcspi: Add FIFO buffer support

Matthias Brugger (1):
  spi: spi-omap2-mcspi.c: Add dts for slave device configuration.

 Documentation/devicetree/bindings/spi/omap-spi.txt |   19 ++
 drivers/spi/spi-omap2-mcspi.c                      |  199 ++++++++++++++++++--
 include/linux/platform_data/spi-omap2-mcspi.h      |    1 +
 3 files changed, 203 insertions(+), 16 deletions(-)


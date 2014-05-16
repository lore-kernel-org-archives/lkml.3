Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbaEPMSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:18:07 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50197 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038AbaEPMSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:18:01 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>, <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: [PATCH v3 00/13]  ARM/DT: edma: IP configuration from hardware and cleanups
Date: Fri, 16 May 2014 15:17:07 +0300
Message-ID: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Changes since v2:
- Comments from Sekhar and Arnd has been addressed best as I could.
- Use the CCCFG information in all cases instead of pdata provided information
- To achieve this I needed to do a bit more cleanup in this series
- In the documentation patch, retrain the old properties for reference
- Cleanups in the old davinci board files and removing edma_soc_info members

Changes sicne v1:
- added missing patch to remove the memset from edma_of_parse_dt()

We are requesting redundant information via DT for the driver since the very same
data is available in the HW: by reading and decoding the content of CCCFG
register we can get:
Number of channels: NUM_DMACH
Number of regions: NUM_REGN
Number of slots (PaRAM sets): NUM_PAENTRY
Number of TC/EQ: NUM_EVQUE

So these does not need to be provided by the DT binding.

The driver will no longer look for these properties from DT and they can be
removed from the binding documentation and from the dtsi files as well.
The change will not introduce regression when new kernel is booted using older
DTB (since we just ignore the mentioned properties).

Regards,
Peter
---
Peter Ujfalusi (13):
  ARM: edma: No need to clean the pdata in edma_of_parse_dt()
  ARM: edma: Take the number of tc from edma_soc_info (pdata)
  ARM: edma: Do not change TC -> Queue mapping, leave it to default.
  ARM: davinci: Remove eDMA3 queue_tc_mapping data from edma_soc_info
  ARM/platform_data: edma: Remove queue_tc_mapping data from
    edma_soc_info
  ARM: edma: Remove num_cc member from struct edma
  ARM: edma: Save number of regions from pdata to struct edma
  ARM: edma: Get IP configuration from HW (number of channels, tc, etc)
  dt/bindings: ti,edma: Remove redundant properties from documentation
  ARM: dts: am33xx: Remove obsolete properties from edma node
  ARM: dts: am4372: Remove obsolete properties from edma node
  ARM: davinci: Remove redundant/unused parameters for edma
  ARM/platform_data: edma: Remove redundant/unused parameters from
    edma_soc_info

 Documentation/devicetree/bindings/dma/ti-edma.txt |  13 +-
 arch/arm/boot/dts/am33xx.dtsi                     |   3 -
 arch/arm/boot/dts/am4372.dtsi                     |   3 -
 arch/arm/common/edma.c                            | 149 +++++++++++-----------
 arch/arm/mach-davinci/devices-da8xx.c             |  31 -----
 arch/arm/mach-davinci/dm355.c                     |  14 --
 arch/arm/mach-davinci/dm365.c                     |  16 ---
 arch/arm/mach-davinci/dm644x.c                    |  14 --
 arch/arm/mach-davinci/dm646x.c                    |  16 ---
 include/linux/platform_data/edma.h                |   8 --
 10 files changed, 81 insertions(+), 186 deletions(-)

-- 
1.9.3


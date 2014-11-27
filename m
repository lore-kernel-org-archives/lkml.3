Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbaK0Kmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:42:33 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33924 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102AbaK0Km1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:42:27 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@kernel.org>, <linux@arm.linux.org.uk>,
        <nsekhar@ti.com>, <arnd@arndb.de>, <vinod.koul@intel.com>,
        <khilman@deeprootsystems.com>
CC: Liam Girdwood <lgirdwood@gmail.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, <ulf.hansson@linaro.org>,
        <chris@printf.net>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mmc@vger.kernel.org>, <linux-spi@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        <dmaengine@vger.kernel.org>
Subject: [PATCH 0/3] ARM: edma: Correct header file usage
Date: Thu, 27 Nov 2014 12:41:28 +0200
Message-ID: <1417084891-17990-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The linux/platform_data/edma.h file was used for API definition as well, which
is not correct since the header should only contain platform data related
structures, defines, etc.

Mark: I think this series can go via arm since it is just changing include stuff
under ASoC.

Regards,
Peter
---
Peter Ujfalusi (3):
  ASoC: davinci-evm: Do not include edma headers
  ARM: edma: Rename header file for dmaengine filter function definition
  ARM: edma: Split up header file to platform_data and API file

 arch/arm/common/edma.c                     |   3 +-
 arch/arm/mach-davinci/devices.c            |   1 +
 arch/arm/mach-davinci/include/mach/da8xx.h |   1 +
 drivers/dma/edma.c                         |   2 +-
 drivers/mmc/host/davinci_mmc.c             |   3 +-
 drivers/spi/spi-davinci.c                  |   2 +-
 include/linux/edma-dmaengine.h             |  29 ++++++
 include/linux/edma.h                       | 152 ++++++++++++++++++++++++++---
 include/linux/platform_data/edma.h         | 148 ++--------------------------
 sound/soc/davinci/davinci-evm.c            |   3 -
 sound/soc/davinci/davinci-pcm.h            |   1 +
 sound/soc/davinci/edma-pcm.c               |   2 +-
 12 files changed, 182 insertions(+), 165 deletions(-)
 create mode 100644 include/linux/edma-dmaengine.h

-- 
2.1.3


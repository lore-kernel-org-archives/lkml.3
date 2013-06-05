Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3FEM05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 08:26:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:39597 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877Ab3FEM0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:26:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,806,1363158000"; 
   d="scan'208";a="348479128"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, viresh.kumar@linaro.org,
        Arnd Bergmann <arnd@arndb.de>, Felipe Balbi <balbi@ti.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 0/4] dw_dmac: move to own folder and split
Date: Wed,  5 Jun 2013 15:26:42 +0300
Message-Id: <1370435206-13474-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is split of the dw_dmac driver as suggested by Arnd et al [1,2].
There are three most important patches:
 2/4 moves driver to its own folder
 3/4 does the actual split
 4/4 introduces PCI part of the driver

During this files are renamed: mostly means that dw_dmac prefix is eliminated.
I hope to get it ready to be included in v3.11.

[1] http://www.spinics.net/lists/kernel/msg1408174.html
[2] http://www.spinics.net/lists/kernel/msg1408495.html

Changes v1->v2:
 - address Arnd's comments
 - compile test when !CONFIG_PM
 - apply ACKs

Cnages v0->v1:
 - apply Viresh's ACKs
 - append PCI part of the driver
 - test altogether on Intel Medfield
 - add 1/4 to the series as it based on it, but Vinod didn't apply it yet to
   his tree.

Andy Shevchenko (4):
  dw_dmac: don't check resource with devm_ioremap_resource
  dma: move dw_dmac driver to an own directory
  dma: dw: split driver to library part and platform code
  dma: dw: add PCI part of the driver

 MAINTAINERS                               |   3 +-
 drivers/dma/Kconfig                       |  20 +-
 drivers/dma/Makefile                      |   2 +-
 drivers/dma/dw/Kconfig                    |  36 ++++
 drivers/dma/dw/Makefile                   |   8 +
 drivers/dma/{dw_dmac.c => dw/core.c}      | 316 ++++-------------------------
 drivers/dma/dw/internal.h                 |  70 +++++++
 drivers/dma/dw/pci.c                      | 101 ++++++++++
 drivers/dma/dw/platform.c                 | 317 ++++++++++++++++++++++++++++++
 drivers/dma/{dw_dmac_regs.h => dw/regs.h} |   1 +
 10 files changed, 573 insertions(+), 301 deletions(-)
 create mode 100644 drivers/dma/dw/Kconfig
 create mode 100644 drivers/dma/dw/Makefile
 rename drivers/dma/{dw_dmac.c => dw/core.c} (85%)
 create mode 100644 drivers/dma/dw/internal.h
 create mode 100644 drivers/dma/dw/pci.c
 create mode 100644 drivers/dma/dw/platform.c
 rename drivers/dma/{dw_dmac_regs.h => dw/regs.h} (99%)

-- 
1.8.2.rc0.22.gb3600c3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab3EaPuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:50:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:34211 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab3EaPui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:50:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,779,1363158000"; 
   d="scan'208";a="346235011"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, viresh.kumar@linaro.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RFC PATCH v0 0/2] dw_dmac: move to own folder and split
Date: Fri, 31 May 2013 18:50:30 +0300
Message-Id: <1370015432-17259-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is first attempt to do split as suggested by Arnd et al.
First patch moves driver to its own folder.
Second one does the actual split.

During this files are renamed: mostly means that dw_dmac prefix is eliminated.
I hope to get it ready to be included in v3.11.

Andy Shevchenko (2):
  dma: move dw_dmac driver to an own directory
  dma: dw: split driver to library part and platform code

 MAINTAINERS                               |   3 +-
 drivers/dma/Kconfig                       |  20 +-
 drivers/dma/Makefile                      |   2 +-
 drivers/dma/dw/Kconfig                    |  27 +++
 drivers/dma/dw/Makefile                   |   5 +
 drivers/dma/{dw_dmac.c => dw/core.c}      | 301 ++++-------------------------
 drivers/dma/dw/internal.h                 |  50 +++++
 drivers/dma/dw/platform.c                 | 306 ++++++++++++++++++++++++++++++
 drivers/dma/{dw_dmac_regs.h => dw/regs.h} |   1 +
 9 files changed, 426 insertions(+), 289 deletions(-)
 create mode 100644 drivers/dma/dw/Kconfig
 create mode 100644 drivers/dma/dw/Makefile
 rename drivers/dma/{dw_dmac.c => dw/core.c} (86%)
 create mode 100644 drivers/dma/dw/internal.h
 create mode 100644 drivers/dma/dw/platform.c
 rename drivers/dma/{dw_dmac_regs.h => dw/regs.h} (99%)

-- 
1.8.2.rc0.22.gb3600c3


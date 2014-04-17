Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbaDQIXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:23:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:64313 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207AbaDQIXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:23:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,877,1389772800"; 
   d="scan'208";a="522117171"
From: Chew Chiau Ee <chiau.ee.chew@intel.com>
To: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc: Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Add PCI mode support for BayTrail LPSS SPI
Date: Fri, 18 Apr 2014 00:26:05 +0800
Message-Id: <1397751967-20250-1-git-send-email-chiau.ee.chew@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chew, Chiau Ee <chiau.ee.chew@intel.com>

Hi,

BayTrail LPSS subsystem consists of one SPI host which can be PCI
enumerated. PXA2XX PCI layer used to support only CE4100's SPI. Thus,
we convert it into a generic PCI layer to add support for LPSS
SPI as well.

Since PCI mode LPSS SPI does not rely on common clock framework, we
need a mechanism to pass in the host supported clock rate to core layer.
Thus, we introduced a new member known as "max_clk_rate" under struct
pxa2xx_spi_master which can be used in PCI glue layer to pass in
host supported clock rate info.

Chew, Chiau Ee (2):
  spi/pxa2xx-pci: Add PCI mode support for BayTrail LPSS SPI
  spi/pxa2xx-pci: Pass host clock rate info from PCI glue layer

 Documentation/spi/pxa2xx       |    3 ++
 drivers/spi/spi-pxa2xx-pci.c   |   79 ++++++++++++++++++++++++++++++++--------
 drivers/spi/spi-pxa2xx.c       |    2 +
 include/linux/spi/pxa2xx_spi.h |    1 +
 4 files changed, 70 insertions(+), 15 deletions(-)

-- 
1.7.4.4


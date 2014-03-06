Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbaCFJY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:24:57 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:32976 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbaCFJU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:20:56 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH 0/7] of: setup dma parameters using dma-ranges and dma-coherent
Date: Thu, 6 Mar 2014 17:19:51 +0800
Message-ID: <1394097598-17622-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on comments from [1] discussion, it seems there is a need to
have a generic support to configure dma device parameters.
Series introduces support for setting up dma parameters based on
device tree properties like 'dma-ranges' and 'dma-coherent'.

The 'dma-ranges' helps to take care of few DMAable system memory restrictions
by use of dma_pfn_offset which we maintain now per device. Arch code then
uses it for dma address translations for such cases. We also setup
dma_mask accordingly during the device creation process.

The 'dma-coherent' property is used to setup coherent dma_ops. Arches
which are always coherent can make use of ARCH_IS_DMA_COHERENT to setup
coherent dma_ops always irrespective of 'dma-coherent' property.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>

Grygorii Strashko (3):
  of: introduce of_dma_get_range() helper
  of: configure the platform device dma_mask and dma_pfn_offset
  ARM: dma: Use dma_pfn_offset for dma address translation

Santosh Shilimkar (4):
  device: introduce per device dma_pfn_offset
  of: introduce of_dma_is_coherent() helper
  of: Add set_arch_dma_coherent_ops() and setup coherent dma_ops
  ARM: dma: implement set_arch_dma_coherent_ops()

 arch/arm/include/asm/dma-mapping.h |   24 ++++-
 drivers/of/platform.c              |  196 +++++++++++++++++++++++++++++++++++-
 include/linux/device.h             |    2 +
 include/linux/dma-mapping.h        |    7 ++
 include/linux/of_platform.h        |   14 +++
 5 files changed, 236 insertions(+), 7 deletions(-)

Regards,
Santosh
[1] http://www.spinics.net/lists/arm-kernel/msg311678.html
-- 
1.7.9.5


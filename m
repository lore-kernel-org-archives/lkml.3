Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaDSOeT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 10:34:19 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58829 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaDSOeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 10:34:15 -0400
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
Subject: [PATCH v2 0/7] of: setup dma parameters using dma-ranges and dma-coherent
Date: Sat, 19 Apr 2014 10:32:45 -0400
Message-ID: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is an updated version of [2] based on discussion. Series introduces
support for setting up dma parameters based on device tree properties
like 'dma-ranges' and 'dma-coherent' and also update to ARM 32 bit port.
Earlier version of the same series is here [1].

The 'dma-ranges' helps to take care of few DMAable system memory restrictions
by use of dma_pfn_offset which we maintain now per device. Arch code then
uses it for dma address translations for such cases. We update the
dma_pfn_offset accordingly during DT the device creation process.The
'dma-coherent' property is used to setup arch's coherent dma_ops.

After some off-list discussion with RMK and Arnd, I have now dropped the
controversial dma_mask setup code from the series which actually isn't blocking
me as such. Considering rest of the parts of the series are already aligned,
am hoping to get this version merged for 3.16 merge window.

We agreed in last discussion that drivers have the ultimate
responsibility to setup the correct dma mask but then we need to have some
means to see if bus can support what driver has requested for a case where
driver request for bigger mask than what bus supports. I can follow up on
the mask topic if we have broken drivers.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>

Grygorii Strashko (2):
  of: introduce of_dma_get_range() helper
  ARM: dma: Use dma_pfn_offset for dma address translation

Santosh Shilimkar (5):
  device: introduce per device dma_pfn_offset
  of: introduce of_dma_is_coherent() helper
  of: configure the platform device dma parameters
  ARM: dma: implement set_arch_dma_coherent_ops()
  ARM: mm: use phys_addr_t in __dma_page_[cpu_to_dev/dev_to_cpu]

 arch/arm/include/asm/dma-mapping.h |   24 +++++-
 arch/arm/mm/dma-mapping.c          |    4 +-
 drivers/of/platform.c              |  151 ++++++++++++++++++++++++++++++++++++
 include/linux/device.h             |    2 +
 include/linux/dma-mapping.h        |    7 ++
 include/linux/of_platform.h        |   15 ++++
 6 files changed, 197 insertions(+), 6 deletions(-)

Regards,
Santosh

[1] http://www.spinics.net/lists/arm-kernel/msg311678.html
[2] https://lkml.org/lkml/2014/3/6/186 
-- 
1.7.9.5


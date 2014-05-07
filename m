Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123AbaEGOFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:05:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49970 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932243AbaEGOFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:05:51 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux@arm.linux.org.uk>, <arm@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <grygorii.strashko@ti.com>,
        <arnd@arndb.de>, <robh+dt@kernel.org>, <catalin.marinas@arm.com>,
        <linus.walleij@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [GIT PULL] DT dma proprties support and ARM arch updates for 3.16
Date: Wed, 7 May 2014 10:05:10 -0400
Message-ID: <1399471510-22382-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell and ARM-SOC folks,

Please pull below series which adds device tree support for dma
properties (dma-ranges and dma-coherent) and respective ARM
architecture updates. As aligned, this series needs to be pulled in
RMK's tree as well as ARM-SOC tree to avoid any merge conflicts with
other changes. Rob H has already acked the dt part to be merged via above
trees. Once the series is pulled in ARM-SOC tree, I will send Keystone
SOC update which makes use of it.

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git tags/dt-dma-properties-for-arm

for you to fetch changes up to 2161c2485d03520060f6094359b22f33913eefa2:

  ARM: dma: use phys_addr_t in __dma_page_[cpu_to_dev/dev_to_cpu] (2014-05-07 09:21:45 -0400)

----------------------------------------------------------------
DT support for 'dma-ranges'and 'dma-coherent' properties with ARM updates

- The 'dma-ranges' helps to take care of few DMAable system memory
        restrictions by use of dma_pfn_offset which is maintained per
        device. Arch code then uses it for dma address translations for such
        cases. We update the dma_pfn_offset accordingly during DT the device
        creation process.
- The 'dma-coherent' property is used to setup arch's coherent dma_ops.

----------------------------------------------------------------
Grygorii Strashko (2):
      of: introduce of_dma_get_range() helper
      ARM: dma: Use dma_pfn_offset for dma address translation

Santosh Shilimkar (5):
      device: introduce per device dma_pfn_offset
      of: introduce of_dma_is_coherent() helper
      of: configure the platform device dma parameters
      ARM: dma: implement set_arch_dma_coherent_ops()
      ARM: dma: use phys_addr_t in __dma_page_[cpu_to_dev/dev_to_cpu]

 arch/arm/include/asm/dma-mapping.h |   25 +++++++-
 arch/arm/mm/dma-mapping.c          |    4 +-
 drivers/of/address.c               |  110 ++++++++++++++++++++++++++++++++++++
 drivers/of/platform.c              |   65 +++++++++++++++++++--
 include/linux/device.h             |    2 +
 include/linux/dma-mapping.h        |    7 +++
 include/linux/of_address.h         |   14 +++++
 7 files changed, 218 insertions(+), 9 deletions(-)

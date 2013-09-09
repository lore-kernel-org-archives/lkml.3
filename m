Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab3IIO2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:28:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63971 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab3IIO2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:28:39 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-2b-522ddb15409b
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] DMA-mapping updates for v3.12
Date: Mon, 09 Sep 2013 16:27:51 +0200
Message-id: <1378736871-22647-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJMWRmVeSWpSXmKPExsVy+t9jAV3R27pBBv+X2Fhc3jWHzWLtkbvs
	Fo/63rI7MHucmPGbxaNvyypGj8+b5AKYo7hsUlJzMstSi/TtErgyfnWsZil4JFHxb2szawNj
	q1AXIweHhICJRGtjahcjJ5ApJnHh3nq2LkYuDiGBRYwSB3/fZIVw2pkkvuw6zQJSxSZgKNH1
	tosNxBYRMJL4/OIKK4jNLOArcefVKrAaYaCa6Yu+MoMsYBFQlZjdVAMS5hXwkNjYuJQFYq+C
	xJxJNhMYuRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECPbyM6kdjCsbLA4xCnAwKvHw
	BhzTDRJiTSwrrsw9xCjBwawkwit6GCjEm5JYWZValB9fVJqTWnyIUZqDRUmc90CrdaCQQHpi
	SWp2ampBahFMlomDU6qBcfWa9Yf+nudYtUVK7vyLzZU7Nn5nF+C4N+nhr1S7xgPtT0MVuxp7
	DqkcSZksfXS7Xrax+Ds1lme+x3/VNVg0XZ0W/lu++rxUo+Y07zMWpd8uS80Icd+r9Gfq8UL2
	zem9T5JkvrfodD8OqF7/0WVV8GXfpr7V++25GRpsvqWK7JjmGr0k6VZWvhJLcUaioRZzUXEi
	AEhMWjzuAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask You for pulling an update of Contiguous Memory
Allocator driver for dma-mapping subsystem for v3.12.


The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git for-v3.12

for you to fetch changes up to 10bcdfb8ba24760f715f0a700c3812747eddddf5:

  ARM: init: add support for reserved memory defined by device tree (2013-08-27 10:53:45 +0200)

----------------------------------------------------------------
Aneesh Kumar K.V (1):
      mm/cma: Move dma contiguous changes into a seperate config

Marek Szyprowski (5):
      Merge remote-tracking branch 'dma-public/for-v3.12-cma-dma' into for-next
      drivers: dma-contiguous: clean source code and prepare for device tree
      drivers: of: add function to scan fdt nodes given by path
      drivers: of: add initialization code for dma reserved memory
      ARM: init: add support for reserved memory defined by device tree

 Documentation/devicetree/bindings/memory.txt |  168 +++++++++++++++++++++++++
 arch/arm/include/asm/dma-contiguous.h        |    3 +-
 arch/arm/mm/dma-mapping.c                    |    6 +-
 arch/arm/mm/init.c                           |    3 +
 arch/x86/include/asm/dma-contiguous.h        |    1 -
 drivers/base/Kconfig                         |   20 +--
 drivers/base/Makefile                        |    2 +-
 drivers/base/dma-contiguous.c                |  119 +++++++-----------
 drivers/of/Kconfig                           |    6 +
 drivers/of/Makefile                          |    1 +
 drivers/of/fdt.c                             |   76 +++++++++++
 drivers/of/of_reserved_mem.c                 |  175 ++++++++++++++++++++++++++
 drivers/of/platform.c                        |    4 +
 include/asm-generic/dma-contiguous.h         |   28 -----
 include/linux/device.h                       |    2 +-
 include/linux/dma-contiguous.h               |   64 +++++++++-
 include/linux/of_fdt.h                       |    3 +
 include/linux/of_reserved_mem.h              |   14 +++
 mm/Kconfig                                   |   24 ++++
 19 files changed, 589 insertions(+), 130 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/memory.txt
 create mode 100644 drivers/of/of_reserved_mem.c
 delete mode 100644 include/asm-generic/dma-contiguous.h
 create mode 100644 include/linux/of_reserved_mem.h

----------------------------------------------------------------

This pull request contains an addition of Device Tree support for
reserved memory regions (Contiguous Memory Allocator is one of the
drivers for it) and changes required by the KVM extensions for PowerPC
architectue.

This pull will conflict with your tree, please resolve it in the following
way:
mm/Kconfig: use the whole file from your tree
drivers/base/dma-contiguous.c: use the whole file from my tree (it already
contains the changes merged to Your tree)

Thanks!

Best regards
Marek Szyprowski
Samsung Poland R&D Center

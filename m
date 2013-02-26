Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3BZGUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 01:20:41 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26881 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab3BZGUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 01:20:40 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-bc-512c54366be4
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] DMA-mapping updates for v3.9-rc1
Date: Tue, 26 Feb 2013 07:20:29 +0100
Message-id: <1361859629-12984-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJMWRmVeSWpSXmKPExsVy+t9jQV3zEJ1Ag60KFpd3zWGzWHvkLrvF
	o7637A7MHidm/Gbx6NuyitHj8ya5AOYoLpuU1JzMstQifbsEroyl938yFbzjq7j68BJLA+Mb
	7i5GTg4JAROJv4e/M0PYYhIX7q1n62Lk4hASmM4ocenVahYIp51JYurqqWwgVWwChhJdb7vA
	bBEBI4nPL66wgtjMAr4Sd16tYgGxhYGmPun/wQ5iswioSuw8sp0RxOYV8JCYfm8i0DYOoG0K
	EnMm2Uxg5F7AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTI9jPz6R2MK5ssDjEKMDBqMTD
	m8CiEyjEmlhWXJl7iFGCg1lJhJczQztQiDclsbIqtSg/vqg0J7X4EKM0B4uSOC/jqScBQgLp
	iSWp2ampBalFMFkmDk6pBkZP+8BsnsXiqpUexvrrU9/ebnTLcPv/7Br/+0tLBXWfuTutFQw/
	n/p7/zXmJi/rug8JZcufsl5Il0lx7D4R8lNMuiTlpfp3uYxl5RaPPYP+z9770Fa4Vo6ta8+V
	MqeNl2xko6+t+7Xt3eFJAfHTIhQM3KdNmOKudmSvy5zOhNorrBbv1jb7zFViKc5INNRiLipO
	BABNmJGM7wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask You for pulling some fixes and extensions to ARM
dma-mapping subsystem for v3.9-rc1.

The following changes since commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200:

  Linux 3.8 (2013-02-18 15:58:34 -0800)

are available in the git repository at:

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git for-v3.9

for you to fetch changes up to d589829107c5528164a9b7dfe50d0001780865ed:

  ARM: DMA-mapping: fix memory leak in IOMMU dma-mapping implementation (2013-02-25 15:30:44 +0100)

----------------------------------------------------------------

This time all patches are related only to ARM DMA-mapping subsystem. The
main extension provided by this pull request is highmem support. Besides
that it contains a bunch of small bugfixes and cleanups.

Thanks!

Best regards
Marek Szyprowski
Samsung Poland R&D Center


Patch summary:

Hiroshi Doyu (3):
      ARM: dma-mapping: Set arm_dma_set_mask() for iommu->set_dma_mask()
      ARM: dma-mapping: Add macro to_dma_iommu_mapping()
      ARM: dma-mapping: Add arm_iommu_detach_device()

Laurent Pinchart (1):
      ARM: iommu: Include linux/kref.h in asm/dma-iommu.h

Marek Szyprowski (3):
      ARM: dma-mapping: add support for CMA regions placed in highmem zone
      ARM: dma-mapping: use himem for DMA buffers for IOMMU-mapped devices
      ARM: DMA-mapping: fix memory leak in IOMMU dma-mapping implementation

Prathyush K (1):
      arm: dma mapping: export arm iommu functions

Seung-Woo Kim (1):
      ARM: dma-mapping: Add maximum alignment order for dma iommu buffers

 arch/arm/Kconfig                 |   21 ++++++++
 arch/arm/include/asm/device.h    |    6 +++
 arch/arm/include/asm/dma-iommu.h |    2 +
 arch/arm/mm/dma-mapping.c        |  108 +++++++++++++++++++++++++++++++-------
 4 files changed, 117 insertions(+), 20 deletions(-)

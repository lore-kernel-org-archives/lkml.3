Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbaGBSDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 14:03:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51914 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaGBSDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 14:03:46 -0400
From: Laura Abbott <lauraa@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: Laura Abbott <lauraa@codeaurora.org>,
        David Riley <davidriley@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        Ritesh Harjain <ritesh.harjani@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: [PATCHv4 0/5] DMA Atomic pool for arm64
Date: Wed,  2 Jul 2014 11:03:33 -0700
Message-Id: <1404324218-4743-1-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the latest in a series to add support for atomic DMA allocations
for non-coherent/CMA code paths in arm64. I did some refactoring to have
arm also use genalloc and pull out some of the remapping code.

This could probably use more testing on other platforms, especially those
that have CONFIG_ARM_DMA_USE_IOMMU set.

Thanks,
Laura

v4: Simplified the logic in gen_pool_first_fit_order_align which makes the
data argument actually unused.

v3: Now a patch series due to refactoring of arm code. arm and arm64 now both
use genalloc for atomic pool management. genalloc extensions added.
DMA remapping code factored out as well.

v2: Various bug fixes pointed out by David and Ritesh (CMA dependency, swapping
coherent, noncoherent). I'm still not sure how to address the devicetree
suggestion by Will [1][2]. I added the devicetree mailing list this time around
to get more input on this.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-April/249180.html
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-April/249528.html


Laura Abbott (5):
  lib/genalloc.c: Add power aligned algorithm
  lib/genalloc.c: Add genpool range check function
  common: dma-mapping: Introduce common remapping functions
  arm: use genalloc for the atomic pool
  arm64: Add atomic pool for non-coherent and CMA allocations.

 arch/arm/Kconfig                         |   1 +
 arch/arm/mm/dma-mapping.c                | 200 ++++++++-----------------------
 arch/arm64/Kconfig                       |   1 +
 arch/arm64/mm/dma-mapping.c              | 154 +++++++++++++++++++++---
 drivers/base/dma-mapping.c               |  67 +++++++++++
 include/asm-generic/dma-mapping-common.h |   9 ++
 include/linux/genalloc.h                 |   7 ++
 lib/genalloc.c                           |  49 ++++++++
 8 files changed, 323 insertions(+), 165 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


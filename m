Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbaHKXkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 19:40:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36307 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbaHKXkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 19:40:39 -0400
From: Laura Abbott <lauraa@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: Laura Abbott <lauraa@codeaurora.org>,
        David Riley <davidriley@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        Ritesh Harjain <ritesh.harjani@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv7 0/5] DMA Atomic pool for arm64
Date: Mon, 11 Aug 2014 16:40:26 -0700
Message-Id: <1407800431-21566-1-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is v7 of the series to add an atomic pool for arm64 and refactor some
of the dma atomic code. You know the drill.

Thanks,
Laura

v7: Added correct power aligned algorithm patch. Addressed comments from
Andrew.

Laura Abbott (5):
  lib/genalloc.c: Add power aligned algorithm
  lib/genalloc.c: Add genpool range check function
  common: dma-mapping: Introduce common remapping functions
  arm: use genalloc for the atomic pool
  arm64: Add atomic pool for non-coherent and CMA allocations.

 arch/arm/Kconfig                         |   1 +
 arch/arm/mm/dma-mapping.c                | 210 +++++++++----------------------
 arch/arm64/Kconfig                       |   1 +
 arch/arm64/mm/dma-mapping.c              | 164 +++++++++++++++++++++---
 drivers/base/dma-mapping.c               |  68 ++++++++++
 include/asm-generic/dma-mapping-common.h |   9 ++
 include/linux/genalloc.h                 |   7 ++
 lib/genalloc.c                           |  49 ++++++++
 8 files changed, 338 insertions(+), 171 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


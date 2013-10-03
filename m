Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab3JCJvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 05:51:01 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:53550 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab3JCJu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:50:59 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergman <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 0/2] arm: add early_ioremap support
Date: Thu,  3 Oct 2013 10:49:14 +0100
Message-Id: <1380793756-2562-1-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for early_ioremap and early_memremap, based
on the existing mechanism in x86. Up to 7 regions of up to 128KB each
can be temporarily mapped in before paging_init, regardless of later
highmem status.

New for this version:
- Addressed feedback on v2
- *cough* corrected early_memremap() to use MT_WRITEALLOC instead
  of MT_UNCACHED.

Cc: Nicolas Pitre <nico@linaro.org>
Cc: Arnd Bergman <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>

Leif Lindholm (2):
  Documentation: arm: early_ioremap/early_memremap
  arm: add early_ioremap support

 Documentation/arm/00-INDEX          |    2 +
 Documentation/arm/early_ioremap.txt |   23 +++
 arch/arm/Kconfig                    |    9 ++
 arch/arm/include/asm/fixmap.h       |   29 +++-
 arch/arm/include/asm/io.h           |   23 +++
 arch/arm/kernel/setup.c             |    3 +
 arch/arm/mm/Makefile                |    1 +
 arch/arm/mm/early_ioremap.c         |  271 +++++++++++++++++++++++++++++++++++
 arch/arm/mm/mmu.c                   |    2 +
 9 files changed, 362 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/arm/early_ioremap.txt
 create mode 100644 arch/arm/mm/early_ioremap.c

-- 
1.7.10.4


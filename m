Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab3FYRl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:41:57 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:32842 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3FYRlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:41:55 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, nico@linaro.org,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH 0/2] arm: add early_ioremap() support
Date: Tue, 25 Jun 2013 18:46:39 +0100
Message-Id: <1372182401-11029-1-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 and ia64 have the early_ioremap()/early_iounmap() functions, which are
useful for supporting things like UEFI, ACPI and SMBIOS, where configuration
tables need to be parsed before proper memory management is available,
regardless of highmem status.

This patchset implements a restricted form of early_ioremap(), available
before paging_init() only. Like the x86 code on which it is based, it
(p)re-uses the fixmap regions for its virtual mapping range. Up to 7
simultaneous mappings of up to 128KB can be accommodated in the available
fixmap space.

Leif Lindholm (2):
  Documentation: arm: early_ioremap
  arm: add early_ioremap support

 Documentation/arm/00-INDEX          |    2 +
 Documentation/arm/early_ioremap.txt |   12 ++
 arch/arm/Kconfig                    |    7 +
 arch/arm/include/asm/fixmap.h       |   31 +++-
 arch/arm/include/asm/io.h           |   13 ++
 arch/arm/kernel/setup.c             |    3 +
 arch/arm/mm/Makefile                |    1 +
 arch/arm/mm/early_ioremap.c         |  273 +++++++++++++++++++++++++++++++++++
 arch/arm/mm/mmu.c                   |    2 +
 9 files changed, 342 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/arm/early_ioremap.txt
 create mode 100644 arch/arm/mm/early_ioremap.c

-- 
1.7.10.4


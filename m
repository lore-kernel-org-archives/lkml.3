Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750917Ab3IFJUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 05:20:18 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36840 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3IFJUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 05:20:16 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, arnd@arndb.de,
        nico@linaro.org, Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH v2 0/2] Add early_ioremap()/early_memremap() support to arm
Date: Fri,  6 Sep 2013 10:19:16 +0100
Message-Id: <1378459158-2145-1-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 and ia64 have the early_ioremap()/early_memremap() functions, which
are useful for supporting things like UEFI, ACPI and SMBIOS, where
configuration tables need to be parsed before proper memory management
is available, regardless of highmem status.

This patchset implements a restricted form of early_ioremap() and
early_memremap(), available before paging_init() only. Like the x86 code
on which it is based, it (p)re-uses the fixmap regions for its virtual
mapping range. Up to 7 simultaneous mappings of up to 128KB can be
accommodated in the available fixmap space.

New for this version is the addition of the early_memremap() call,
which maps a region in with uncached normal memory type.

Leif Lindholm (2):
  Documentation: arm: early_ioremap/early_memremap
  arm: add early_ioremap support

 Documentation/arm/00-INDEX          |    2 +
 Documentation/arm/early_ioremap.txt |   23 +++
 arch/arm/Kconfig                    |    7 +
 arch/arm/include/asm/fixmap.h       |   31 +++-
 arch/arm/include/asm/io.h           |   17 +++
 arch/arm/kernel/setup.c             |    5 +
 arch/arm/mm/Makefile                |    1 +
 arch/arm/mm/early_ioremap.c         |  271 +++++++++++++++++++++++++++++++++++
 arch/arm/mm/mmu.c                   |    4 +
 9 files changed, 359 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/arm/early_ioremap.txt
 create mode 100644 arch/arm/mm/early_ioremap.c

-- 
1.7.10.4


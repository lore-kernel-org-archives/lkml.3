Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751124AbaLOSFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 13:05:55 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:53985 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaLOSFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 13:05:54 -0500
From: Aleksey Makarov <feumilieu@gmail.com>
X-Google-Original-From: Aleksey Makarov <aleksey.makarov@auriga.com>
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>
Subject: [PATCH 00/14] MIPS: OCTEON: Some partial support for Octeon III
Date: Mon, 15 Dec 2014 21:03:06 +0300
Message-Id: <1418666603-15159-1-git-send-email-aleksey.makarov@auriga.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix some issues in the Cavium Octeon code and
introduce some partial support for Octeon III and little-endian.

Aleksey Makarov (1):
  MIPS: OCTEON: Delete unused COP2 saving code

Chandrakala Chavva (1):
  MIPS: OCTEON: Use correct instruction to read 64-bit COP0 register

David Daney (12):
  MIPS: OCTEON: Save/Restore wider multiply registers in OCTEON III CPUs
  MIPS: OCTEON: Fix FP context save.
  MIPS: OCTEON: Save and restore CP2 SHA3 state
  MIPS: Remove unneeded #ifdef __KERNEL__ from asm/processor.h
  MIPS: OCTEON: Implement the core-16057 workaround
  MIPS: OCTEON: Don't do acknowledge operations for level triggered
    irqs.
  MIPS: OCTEON: Add ability to used an initrd from a named memory block.
  MIPS: OCTEON: Add little-endian support to asm/octeon/octeon.h
  MIPS: OCTEON: Implement DCache errata workaround for all CN6XXX
  MIPS: OCTEON: Update octeon-model.h code for new SoCs.
  MIPS: OCTEON: Add register definitions for OCTEON III reset unit.
  MIPS: OCTEON: Handle OCTEON III in csrc-octeon.

 arch/mips/cavium-octeon/csrc-octeon.c              |  10 +
 arch/mips/cavium-octeon/octeon-irq.c               |  45 ++-
 arch/mips/cavium-octeon/setup.c                    |  81 +++-
 arch/mips/include/asm/bootinfo.h                   |   1 +
 .../asm/mach-cavium-octeon/kernel-entry-init.h     |  22 +
 arch/mips/include/asm/mach-cavium-octeon/war.h     |   3 +
 arch/mips/include/asm/octeon/cvmx-rst-defs.h       | 441 +++++++++++++++++++++
 arch/mips/include/asm/octeon/octeon-model.h        |  65 ++-
 arch/mips/include/asm/octeon/octeon.h              | 148 +++++--
 arch/mips/include/asm/processor.h                  |   8 +-
 arch/mips/include/asm/ptrace.h                     |   4 +-
 arch/mips/kernel/asm-offsets.c                     |   1 +
 arch/mips/kernel/octeon_switch.S                   | 218 ++++++----
 arch/mips/kernel/setup.c                           |  19 +-
 arch/mips/mm/uasm.c                                |   2 +-
 15 files changed, 935 insertions(+), 133 deletions(-)
 create mode 100644 arch/mips/include/asm/octeon/cvmx-rst-defs.h

-- 
2.1.3


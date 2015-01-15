Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbbAONLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:11:38 -0500
Received: from nivc-ms1.auriga.com ([80.240.102.146]:17876 "EHLO
	nivc-ms1.auriga.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbbAONLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:11:34 -0500
From: Aleksey Makarov <aleksey.makarov@auriga.com>
To: <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>
Subject: [PATCH v3 00/15] MIPS: OCTEON: Some partial support for Octeon III
Date: Thu, 15 Jan 2015 16:11:04 +0300
Message-ID: <1421327487-28679-1-git-send-email-aleksey.makarov@auriga.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [80.240.102.213]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v3:

- Reintroduce cvmx-rst-defs.h.  An union from it is used both in
  csrc-octeon.c and setup.c
- File octeon-models.h was updated.  Macro OCTEON_FAM_* were
  removed.
- Patches "Core-15169 Workaround and general CVMSEG cleanup"
  and "Remove setting of processor specific CVMCTL icache bits"
  were added.
- CIB and SUM2 support was added to the irq code.  
  The function of_irq_init() is used now to initialize interrupt
  controllers

Changes in v2:

- Do not introduce cvmx-rst-defs.h. Define all the required
  symbols in csrc-octeon.c
- The patch "MIPS: Remove unneeded #ifdef __KERNEL__ from
  asm/processor.h" will be sent separately as it is not
  OCTEON specific

Summary:

These patches fix some issues in the Cavium Octeon code and
introduce some partial support for Octeon III and little-endian.
Also irq code was changed to support SATA and some other interrutps.

Aleksey Makarov (1):
  MIPS: OCTEON: Delete unused COP2 saving code

Chad Reese (1):
  MIPS: OCTEON: Remove setting of processor specific CVMCTL icache bits.

Chandrakala Chavva (2):
  MIPS: OCTEON: Use correct instruction to read 64-bit COP0 register
  MIPS: OCTEON: More OCTEONIII support

David Daney (11):
  MIPS: OCTEON: Save/Restore wider multiply registers in OCTEON III CPUs
  MIPS: OCTEON: Fix FP context save.
  MIPS: OCTEON: Save and restore CP2 SHA3 state
  MIPS: OCTEON: Implement the core-16057 workaround
  MIPS: OCTEON: Add ability to used an initrd from a named memory block.
  MIPS: OCTEON: Add little-endian support to asm/octeon/octeon.h
  MIPS: OCTEON: Implement DCache errata workaround for all CN6XXX
  MIPS: OCTEON: Update octeon-model.h code for new SoCs.
  MIPS: OCTEON: Core-15169 Workaround and general CVMSEG cleanup.
  MIPS: OCTEON: Don't do acknowledge operations for level triggered
    irqs.
  MIPS: OCTEON: irq: add CIB and other fixes

 .../devicetree/bindings/mips/cavium/cib.txt        |   43 +
 arch/mips/cavium-octeon/csrc-octeon.c              |   11 +-
 arch/mips/cavium-octeon/dma-octeon.c               |    4 +-
 .../cavium-octeon/executive/cvmx-helper-board.c    |    2 +-
 arch/mips/cavium-octeon/octeon-irq.c               | 1094 +++++++++++++++-----
 arch/mips/cavium-octeon/setup.c                    |   93 +-
 arch/mips/include/asm/bootinfo.h                   |    1 +
 .../asm/mach-cavium-octeon/kernel-entry-init.h     |   64 +-
 arch/mips/include/asm/mach-cavium-octeon/war.h     |    3 +
 arch/mips/include/asm/octeon/cvmx-rst-defs.h       |  306 ++++++
 arch/mips/include/asm/octeon/octeon-model.h        |  107 +-
 arch/mips/include/asm/octeon/octeon.h              |  148 ++-
 arch/mips/include/asm/processor.h                  |    2 +
 arch/mips/include/asm/ptrace.h                     |    4 +-
 arch/mips/kernel/asm-offsets.c                     |    1 +
 arch/mips/kernel/octeon_switch.S                   |  218 ++--
 arch/mips/kernel/setup.c                           |   19 +-
 arch/mips/mm/uasm.c                                |    2 +-
 18 files changed, 1675 insertions(+), 447 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/cib.txt
 create mode 100644 arch/mips/include/asm/octeon/cvmx-rst-defs.h

-- 
2.2.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932AbbA0VRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:17:20 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:7707 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbbA0VRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:17:19 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Ralf Baechle <ralf@linux-mips.org>, <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: [PATCH 0/3] Add MIPS CDMM bus support
Date: Tue, 27 Jan 2015 21:16:38 +0000
Message-ID: <1422393401-13543-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.110]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds basic support for the MIPS Common Device Mapped
Memory (CDMM) region in the form of a bus in the standard Linux device
model.

Since the CDMM region is a feature of the MIPS architecture (since
around MIPSr2) the first patch adds the necessary definitions and
probing to arch/mips.

The second patch adds the actual bus driver (see that patch for lots
more info). 

The final patch just enables CDMM to work on Malta.

Futher patches will follow soon to add TTY/Console/KGDB support for the
EJTAG Fast Debug Channel (FDC) device which is found in the CDMM region.

Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mips@linux-mips.org

James Hogan (3):
  MIPS: Add arch CDMM definitions and probing
  MIPS: Add CDMM bus support
  MIPS: Malta: Implement mips_cdmm_phys_base()

 arch/mips/include/asm/cdmm.h         |  87 +++++
 arch/mips/include/asm/cpu-features.h |   4 +
 arch/mips/include/asm/cpu.h          |   1 +
 arch/mips/include/asm/mipsregs.h     |  11 +
 arch/mips/kernel/cpu-probe.c         |   2 +
 arch/mips/mti-malta/malta-memory.c   |   7 +
 drivers/bus/Kconfig                  |  13 +
 drivers/bus/Makefile                 |   1 +
 drivers/bus/mips_cdmm.c              | 710 +++++++++++++++++++++++++++++++++++
 include/linux/mod_devicetable.h      |   8 +
 scripts/mod/devicetable-offsets.c    |   3 +
 scripts/mod/file2alias.c             |  16 +
 12 files changed, 863 insertions(+)
 create mode 100644 arch/mips/include/asm/cdmm.h
 create mode 100644 drivers/bus/mips_cdmm.c

-- 
2.0.5


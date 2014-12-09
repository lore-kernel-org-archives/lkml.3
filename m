Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaLIRex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 12:34:53 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36544 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaLIRew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 12:34:52 -0500
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, mpe@ellerman.id.au
Cc: ananth@in.ibm.com
Subject: [RFC PATCH 0/8] Fix perf probe issues on powerpc
Date: Tue,  9 Dec 2014 23:03:58 +0530
Message-Id: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.1.3
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120917-0025-0000-0000-000000B14C25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes various issues with perf probe on powerpc
across ABIv1 and ABIv2:
- in the presence of DWARF debug-info,
- in the absence of DWARF, but with the symbol table, and
- in the absence of debug-info, but with kallsyms.

Applies cleanly on v3.18 and on -tip with minor changes to patch 6.
Tested on ppc64 BE and LE.

- Naveen

Naveen N. Rao (8):
  kprobes: Fix kallsyms lookup across powerpc ABIv1 and ABIv2
  perf probe powerpc: Fix symbol fixup issues due to ELF type
  perf probe: Improve detection of file/function name in the probe
    pattern
  perf probe powerpc: Handle powerpc dot symbols
  perf probe powerpc: Allow matching against dot symbols
  perf tools powerpc: Fix PPC64 ELF ABIv2 symbol decoding
  perf probe powerpc: Use DWARF info only if necessary
  perf probe powerpc: Fixup function entry if using kallsyms lookup

 arch/powerpc/include/asm/code-patching.h      | 26 ++++++++----
 arch/powerpc/include/asm/kprobes.h            | 58 ++++++++++++++++++---------
 tools/perf/arch/powerpc/Makefile              |  1 +
 tools/perf/arch/powerpc/util/elf-sym-decode.c | 27 +++++++++++++
 tools/perf/config/Makefile                    |  1 +
 tools/perf/util/elf_sym.h                     | 13 ++++++
 tools/perf/util/probe-event.c                 | 57 ++++++++++++++++++++++++--
 tools/perf/util/symbol-elf.c                  | 11 ++++-
 tools/perf/util/symbol.c                      |  6 +++
 9 files changed, 170 insertions(+), 30 deletions(-)
 create mode 100644 tools/perf/arch/powerpc/util/elf-sym-decode.c
 create mode 100644 tools/perf/util/elf_sym.h

-- 
2.1.3


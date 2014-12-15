Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbaLOOvC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:51:02 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:35397 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaLOOu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:50:58 -0500
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, mpe@ellerman.id.au
Cc: ananth@in.ibm.com
Subject: [PATCHv2 0/8] Fix perf probe issues on powerpc
Date: Mon, 15 Dec 2014 20:20:30 +0530
Message-Id: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.1.3
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121514-0029-0000-0000-000000D1CF34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes various issues with perf probe on powerpc across ABIv1 and
ABIv2:
- in the presence of DWARF debug-info,
- in the absence of DWARF, but with the symbol table, and
- in the absence of debug-info, but with kallsyms.

Applies cleanly on -tip. Tested on ppc64 BE and LE.

Changes from previous version:
Addressed various review comments from Mike Ellerman largely to generalize
changes. Some of the simpler patches have been retained in their previous form
to limit code churn, while others have been generalized by introducing arch
helpers. Individual patches have more details.


- Naveen

Naveen N. Rao (8):
  kprobes: Fix kallsyms lookup across powerpc ABIv1 and ABIv2
  perf probe: Improve detection of file/function name in the probe
    pattern
  perf probe powerpc: Fix symbol fixup issues due to ELF type
  perf probe powerpc: Handle powerpc dot symbols
  perf probe powerpc: Allow matching against dot symbols
  perf tools powerpc: Fix PPC64 ELF ABIv2 symbol decoding
  perf probe powerpc: Use DWARF info only if necessary
  perf probe powerpc: Fixup function entry if using kallsyms lookup

 arch/powerpc/include/asm/kprobes.h          | 63 +++++++++++++++++++---------
 tools/perf/arch/powerpc/Makefile            |  1 +
 tools/perf/arch/powerpc/util/sym-handling.c | 64 +++++++++++++++++++++++++++++
 tools/perf/config/Makefile                  |  2 +
 tools/perf/util/probe-event.c               | 48 ++++++++++++++++++----
 tools/perf/util/probe-event.h               | 21 ++++++++++
 tools/perf/util/symbol-elf.c                |  5 ++-
 tools/perf/util/symbol.c                    |  6 +++
 tools/perf/util/symbol.h                    |  6 +++
 9 files changed, 188 insertions(+), 28 deletions(-)
 create mode 100644 tools/perf/arch/powerpc/util/sym-handling.c

-- 
2.1.3


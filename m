Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935893Ab3DPPyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:54:37 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:50668 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933788Ab3DPPyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:54:36 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org
Subject: [PATCH V2 0/5] powerpc, perf: BHRB based branch stack enablement on POWER8
Date: Tue, 16 Apr 2013 21:24:05 +0530
Message-Id: <1366127650-1952-1-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041615-9264-0000-0000-000003894EC1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

                Branch History Rolling Buffer (BHRB) is a new PMU feaure in IBM
POWER8 processor which records the branch instructions inside the execution
pipeline. This patchset enables the basic functionality of the feature through
generic perf branch stack sampling framework.

Sample output
-------------
$./perf record -b top
$./perf report

Overhead  Command  Source Shared Object                           Source Symbol  Target Shared Object                        Target Symbol
# ........  .......  ....................  ......................................  ....................  ...................................
#

     7.82%      top  libc-2.11.2.so        [k] _IO_vfscanf                         libc-2.11.2.so        [k] _IO_vfscanf
     6.17%      top  libc-2.11.2.so        [k] _IO_vfscanf                         [unknown]             [k] 00000000
     2.37%      top  [unknown]             [k] 0xf7aafb30                          [unknown]             [k] 00000000
     1.80%      top  [unknown]             [k] 0x0fe07978                          libc-2.11.2.so        [k] _IO_vfscanf
     1.60%      top  libc-2.11.2.so        [k] _IO_vfscanf                         [kernel.kallsyms]     [k] .do_task_stat
     1.20%      top  [kernel.kallsyms]     [k] .do_task_stat                       [kernel.kallsyms]     [k] .do_task_stat
     1.02%      top  libc-2.11.2.so        [k] vfprintf                            libc-2.11.2.so        [k] vfprintf
     0.92%      top  top                   [k] _init                               [unknown]             [k] 0x0fe037f4

Changes in V2
--------------
- Added copyright messages to the newly created files
- Modified couple of commit messages

Anshuman Khandual (5):
  powerpc, perf: Add new BHRB related instructions on POWER8
  powerpc, perf: Add basic assembly code to read BHRB entries on POWER8
  powerpc, perf: Add new BHRB related generic functions, data and flags
  powerpc, perf: Define BHRB generic functions, data and flags for POWER8
  powerpc, perf: Enable branch stack sampling framework support with BHRB

 arch/powerpc/include/asm/perf_event_server.h |  6 ++
 arch/powerpc/include/asm/ppc-opcode.h        |  7 ++
 arch/powerpc/perf/Makefile                   |  2 +-
 arch/powerpc/perf/bhrb.S                     | 44 +++++++++++++
 arch/powerpc/perf/core-book3s.c              | 96 +++++++++++++++++++++++++++-
 arch/powerpc/perf/perf_event_bhrb.c          | 85 ++++++++++++++++++++++++
 arch/powerpc/perf/power8-pmu.c               | 57 ++++++++++++++++-
 7 files changed, 292 insertions(+), 5 deletions(-)
 create mode 100644 arch/powerpc/perf/bhrb.S
 create mode 100644 arch/powerpc/perf/perf_event_bhrb.c

-- 
1.7.11.7


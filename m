Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaKKF07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 00:26:59 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:60697 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaKKF05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 00:26:57 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
        james.hogan@imgtec.com, avagin@openvz.org, Paul.Clothier@imgtec.com,
        palves@redhat.com, oleg@redhat.com, dhowells@redhat.com,
        davej@redhat.com, davem@davemloft.net, mikey@neuling.org,
        benh@kernel.crashing.org, sukadev@linux.vnet.ibm.com,
        mpe@ellerman.id.au, sam.bobroff@au1.ibm.com
Subject: [PATCH V4 0/8] Add new PowerPC specific ELF core notes
Date: Tue, 11 Nov 2014 10:56:29 +0530
Message-Id: <1415683597-22819-1-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111105-0033-0000-0000-0000007C2135
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This patch series adds five new ELF core note sections which can be
used with existing ptrace request PTRACE_GETREGSET-SETREGSET for accessing
various transactional memory and miscellaneous debug register sets on PowerPC
platform.

Previous versions:
==================
RFC: https://lkml.org/lkml/2014/4/1/292
V1:  https://lkml.org/lkml/2014/4/2/43
V2:  https://lkml.org/lkml/2014/5/5/88
V3:  https://lkml.org/lkml/2014/5/23/486

Changes in V4:
--------------
- Added one test program into the powerpc selftest bucket in this regard
- Split the 2nd patch in the previous series into four different patches
- Accommodated most of the review comments on the previous patch series
- Added a patch to merge functions __switch_to_tm and tm_reclaim_task

Changes in V3:
--------------
- Added two new error paths in every TM related get/set functions when regset
  support is not present on the system (ENODEV) or when the process does not
  have any transaction active (ENODATA) in the context
- Installed the active hooks for all the newly added regset core note types

Changes in V2:
--------------
- Removed all the power specific ptrace requests corresponding to new NT_PPC_*
  elf core note types. Now all the register sets can be accessed from ptrace
  through PTRACE_GETREGSET/PTRACE_SETREGSET using the individual NT_PPC* core
  note type instead
- Fixed couple of attribute values for REGSET_TM_CGPR register set
- Renamed flush_tmreg_to_thread as flush_tmregs_to_thread
- Fixed 32 bit checkpointed GPR support
- Changed commit messages accordingly

Test Result
-----------
The patch series has been verified both in 32 bit and 64 bit compiled mode.
Test result for the selftest test (64 bit compiled mode) can be found here.

test: tm_ptrace
tags: git_version:v3.18-rc4-9-g000adb7
=============Testing TM based PTRACE calls==============
-------TM Specific SPR------
TFHAR: 10000cc8
TEXASR: de0000018c000001
TFIAR: c0000000000414f0
TM ORIG_MSR: 50000f032
TM CH DSCR: a (PASSED)
TM CH TAR: 14 (PASSED)
TM CH PPR: 8000000000000 (PASSED)
-------TM Checkpointed GPR-----
TM CH NIP: 10000cc8
TM CH LINK: 10000af8
TM CH CCR: 22000422
TM CH GPR[0]: 0 (PASSED)
TM CH GPR[1]: 1 (PASSED)
TM CH GPR[2]: 2 (PASSED)
TM CH GPR[3]: 3 (PASSED)
TM CH GPR[4]: 4 (PASSED)
TM CH GPR[5]: 5 (PASSED)
TM CH GPR[6]: 6 (PASSED)
TM CH GPR[7]: 7 (PASSED)
TM CH GPR[8]: 8 (PASSED)
TM CH GPR[9]: 9 (PASSED)
TM CH GPR[10]: a (PASSED)
TM CH GPR[11]: b (PASSED)
TM CH GPR[12]: c (PASSED)
TM CH GPR[13]: d (PASSED)
TM CH GPR[14]: e (PASSED)
TM CH GPR[15]: f (PASSED)
TM CH GPR[16]: 0 (PASSED)
TM CH GPR[17]: 1 (PASSED)
TM CH GPR[18]: 2 (PASSED)
TM CH GPR[19]: 3 (PASSED)
TM CH GPR[20]: 4 (PASSED)
TM CH GPR[21]: 5 (PASSED)
TM CH GPR[22]: 6 (PASSED)
TM CH GPR[23]: 7 (PASSED)
TM CH GPR[24]: 8 (PASSED)
TM CH GPR[25]: 9 (PASSED)
TM CH GPR[26]: a (PASSED)
TM CH GPR[27]: b (PASSED)
TM CH GPR[28]: c (PASSED)
TM CH GPR[29]: d (PASSED)
TM CH GPR[30]: e (PASSED)
TM CH GPR[31]: f (PASSED)
-------TM Checkpointed FPR-----
TM CH FPSCR: 0
TM CH FPR[0]: 0 (PASSED)
TM CH FPR[1]: 1 (PASSED)
TM CH FPR[2]: 2 (PASSED)
TM CH FPR[3]: 3 (PASSED)
TM CH FPR[4]: 4 (PASSED)
TM CH FPR[5]: 5 (PASSED)
TM CH FPR[6]: 6 (PASSED)
TM CH FPR[7]: 7 (PASSED)
TM CH FPR[8]: 8 (PASSED)
TM CH FPR[9]: 9 (PASSED)
TM CH FPR[10]: a (PASSED)
TM CH FPR[11]: b (PASSED)
TM CH FPR[12]: c (PASSED)
TM CH FPR[13]: d (PASSED)
TM CH FPR[14]: e (PASSED)
TM CH FPR[15]: f (PASSED)
TM CH FPR[16]: 0 (PASSED)
TM CH FPR[17]: 1 (PASSED)
TM CH FPR[18]: 2 (PASSED)
TM CH FPR[19]: 3 (PASSED)
TM CH FPR[20]: 4 (PASSED)
TM CH FPR[21]: 5 (PASSED)
TM CH FPR[22]: 6 (PASSED)
TM CH FPR[23]: 7 (PASSED)
TM CH FPR[24]: 8 (PASSED)
TM CH FPR[25]: 9 (PASSED)
TM CH FPR[26]: a (PASSED)
TM CH FPR[27]: b (PASSED)
TM CH FPR[28]: c (PASSED)
TM CH FPR[29]: d (PASSED)
TM CH FPR[30]: e (PASSED)
TM CH FPR[31]: f (PASSED)
-------TM Running GPR-----
TM RN NIP: 10000de0
TM RN LINK: 10000af8
TM RN CCR: 2000422
TM RN GPR[0]: f (PASSED)
TM RN GPR[1]: e (PASSED)
TM RN GPR[2]: d (PASSED)
TM RN GPR[3]: c (PASSED)
TM RN GPR[4]: b (PASSED)
TM RN GPR[5]: a (PASSED)
TM RN GPR[6]: 9 (PASSED)
TM RN GPR[7]: 8 (PASSED)
TM RN GPR[8]: 7 (PASSED)
TM RN GPR[9]: 6 (PASSED)
TM RN GPR[10]: 5 (PASSED)
TM RN GPR[11]: 4 (PASSED)
TM RN GPR[12]: 3 (PASSED)
TM RN GPR[13]: 2 (PASSED)
TM RN GPR[14]: 1 (PASSED)
TM RN GPR[15]: 0 (PASSED)
TM RN GPR[16]: f (PASSED)
TM RN GPR[17]: e (PASSED)
TM RN GPR[18]: d (PASSED)
TM RN GPR[19]: c (PASSED)
TM RN GPR[20]: b (PASSED)
TM RN GPR[21]: a (PASSED)
TM RN GPR[22]: 9 (PASSED)
TM RN GPR[23]: 8 (PASSED)
TM RN GPR[24]: 7 (PASSED)
TM RN GPR[25]: 6 (PASSED)
TM RN GPR[26]: 5 (PASSED)
TM RN GPR[27]: 4 (PASSED)
TM RN GPR[28]: 3 (PASSED)
TM RN GPR[29]: 2 (PASSED)
TM RN GPR[30]: 1 (PASSED)
TM RN GPR[31]: 0 (PASSED)
-------TM Running FPR-----
TM RN FPSCR: 0
TM RN FPR[0]: f (PASSED)
TM RN FPR[1]: e (PASSED)
TM RN FPR[2]: d (PASSED)
TM RN FPR[3]: c (PASSED)
TM RN FPR[4]: b (PASSED)
TM RN FPR[5]: a (PASSED)
TM RN FPR[6]: 9 (PASSED)
TM RN FPR[7]: 8 (PASSED)
TM RN FPR[8]: 7 (PASSED)
TM RN FPR[9]: 6 (PASSED)
TM RN FPR[10]: 5 (PASSED)
TM RN FPR[11]: 4 (PASSED)
TM RN FPR[12]: 3 (PASSED)
TM RN FPR[13]: 2 (PASSED)
TM RN FPR[14]: 1 (PASSED)
TM RN FPR[15]: 0 (PASSED)
TM RN FPR[16]: f (PASSED)
TM RN FPR[17]: e (PASSED)
TM RN FPR[18]: d (PASSED)
TM RN FPR[19]: c (PASSED)
TM RN FPR[20]: b (PASSED)
TM RN FPR[21]: a (PASSED)
TM RN FPR[22]: 9 (PASSED)
TM RN FPR[23]: 8 (PASSED)
TM RN FPR[24]: 7 (PASSED)
TM RN FPR[25]: 6 (PASSED)
TM RN FPR[26]: 5 (PASSED)
TM RN FPR[27]: 4 (PASSED)
TM RN FPR[28]: 3 (PASSED)
TM RN FPR[29]: 2 (PASSED)
TM RN FPR[30]: 1 (PASSED)
TM RN FPR[31]: 0 (PASSED)
-------TM Running MISC Registers-------
TM RN DSCR: 32 (PASSED)
TM RN TAR: 3c (PASSED)
TM RN PPR: 4000000000000 (PASSED)
success: tm_ptrace

Anshuman Khandual (8):
  elf: Add new PowerPC specifc core note sections
  powerpc, process: Add functions flush_tm_state, flush_tmregs_to_thread
  powerpc, process: Merge functions __switch_to_tm and tm_reclaim_task
  powerpc, ptrace: Enable fpr_(get/set) for transactional memory
  powerpc, ptrace: Enable vr_(get/set) for transactional memory
  powerpc, ptrace: Enable support for transactional memory register sets
  powerpc, ptrace: Enable support for miscellaneous debug registers
  selftests, powerpc: Add new test case for TM related ptrace interfaces

 arch/powerpc/include/asm/switch_to.h           |   8 +
 arch/powerpc/include/uapi/asm/elf.h            |   3 +
 arch/powerpc/kernel/process.c                  |  65 +-
 arch/powerpc/kernel/ptrace.c                   | 965 ++++++++++++++++++++++++-
 include/uapi/linux/elf.h                       |   5 +
 tools/testing/selftests/powerpc/tm/Makefile    |   2 +-
 tools/testing/selftests/powerpc/tm/tm-ptrace.c | 529 ++++++++++++++
 7 files changed, 1533 insertions(+), 44 deletions(-)
 create mode 100644 tools/testing/selftests/powerpc/tm/tm-ptrace.c

-- 
1.9.3


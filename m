Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaLPPDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 10:03:48 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:47112 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbaLPPDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 10:03:45 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: [PATCH 00/11] powerpc8xx: Further optimisation of TLB handling
Message-Id: <20141216150337.ECBE91A5E05@localhost.localdomain>
Date: Tue, 16 Dec 2014 16:03:37 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset provides a further optimisation of TLB handling in the 8xx.
Main changes are based on:
- Using processor handling of PGD/PTE Validity bits instead of testing ourselves
the entries validity
- Aligning PGD address to allow direct bit manipulation
- Not saving registers like CR when not needed

It also adds support to any TASK_SIZE

Patchset:
01 - powerpc/8xx: remove remaining unnecessary code in FixupDAR
02 - powerpc/8xx: remove tests on PGDIR entry validity
03 - powerpc32: Use kmem_cache memory for PGDIR
04 - powerpc/8xx: Take benefit of aligned PGDIR
05 - powerpc/8xx: Optimise access to swapper_pg_dir
06 - powerpc/8xx: Remove duplicated code in set_context()
07 - powerpc/8xx: macro for handling CPU15 errata
08 - powerpc/8xx: Handle CR out of exception PROLOG/EPILOG
09 - powerpc/8xx: dont save CR in SCRATCH registers
10 - powerpc/8xx: Use SPRG2 instead of DAR for saving r3
11 - powerpc/8xx: Add support for TASK_SIZE greater than 0x80000000

All changes have been successfully tested on MPC885

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Tested-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 arch/powerpc/include/asm/page.h          |  8 +++----
 arch/powerpc/include/asm/pgtable-ppc32.h | 37 +++++++++++++++++++++-----------
 arch/powerpc/include/asm/pgtable.h       | 17 ++++++++-------
 arch/powerpc/include/asm/pte-8xx.h       |  1 +
 arch/powerpc/include/asm/pte-common.h    |  3 +++
 arch/powerpc/kernel/head_8xx.S           |  3 ---
 arch/powerpc/mm/pgtable_32.c             | 14 ++++++++++++
 7 files changed, 56 insertions(+), 27 deletions(-)

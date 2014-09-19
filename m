Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaISIgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 04:36:14 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:54389 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbaISIgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 04:36:09 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Subject: [PATCH v4 00/21] powerpc/8xx: Optimise MMU TLB handling and add support of 16k pages
Message-Id: <20140919083606.863ED1AB030@localhost.localdomain>
Date: Fri, 19 Sep 2014 10:36:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset:
1) provides several MMU TLB handling optimisation on MPC8xx.
2) adds support of 16k pages on MPC8xx.
All changes have been successfully tested on a custom board equipped with MPC885

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Tested-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
Changes in v2:
- Patch number 10 removed, it was implementing a 16 bit alignment of the PGDIR.
It is not worth potentially wasting up to 64k of memory just for removing one
instruction (ori).
- Preserve r11 while calculating the level 2 address, therefore no more need to
save r11 into CR.

Changes in v3:
- Few fixes following review from Joachim Tjernlund
- Removed the major hack which was saving resisters in memory for CPU6 errata
- Invalidating non present TLB entries earlier (in head_8xx instead of fault.c)

Changes in v4:
- Resubmitting patch 3 and 7 after new comments from Joachim and feedback
from Scott. Has impact on patch 5, 14, 19 and 21.
- Fixed patch 20 that didn't apply

 arch/powerpc/Kconfig                     |   2 +-
 arch/powerpc/include/asm/mmu-8xx.h       |   2 +
 arch/powerpc/include/asm/pgtable-ppc32.h |  20 ++
 arch/powerpc/include/asm/pte-8xx.h       |   7 +-
 arch/powerpc/include/asm/reg.h           |   3 +-
 arch/powerpc/kernel/head_8xx.S           | 366 ++++++++++++-------------
 arch/powerpc/mm/fault.c                  |   7 -
 7 files changed, 201 insertions(+), 206 deletions(-)

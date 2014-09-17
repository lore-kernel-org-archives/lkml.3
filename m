Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbaIQQhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:37:16 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:44076 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888AbaIQQhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:37:11 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Subject: [PATCH v3 00/21] powerpc/8xx: Optimise MMU TLB handling and add support of 16k pages
Message-Id: <20140917163656.E09D81AB026@localhost.localdomain>
Date: Wed, 17 Sep 2014 18:36:56 +0200 (CEST)
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

 arch/powerpc/Kconfig                     |   2 +-
 arch/powerpc/include/asm/mmu-8xx.h       |   2 +
 arch/powerpc/include/asm/pgtable-ppc32.h |  20 ++
 arch/powerpc/include/asm/pte-8xx.h       |   7 +-
 arch/powerpc/include/asm/reg.h           |   3 +-
 arch/powerpc/kernel/head_8xx.S           | 370 ++++++++++++-------------
 arch/powerpc/mm/fault.c                  |   9 +-
 7 files changed, 203 insertions(+), 210 deletions(-)

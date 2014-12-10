Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631AbaLJSBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:01:16 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:18020 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167AbaLJSBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:01:15 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Subject: [PATCH 0/4] powerpc32: fix of PTE accessors and handle inverted HW bits via PTE accessors
Message-Id: <20141210180028.72FA71A5D62@localhost.localdomain>
Date: Wed, 10 Dec 2014 19:00:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some powerpc like the 8xx do invert some PTE bits in HW. In order to avoid
having to invert the bits each time we set them into hardware, this patch adds
the invertion logic into the PTE accessors in order to get them already properly
inversed in the tables.

Patchset:
1) powerpc32: misuse of accessors to pte_t objects
2) powerpc32: properly clear page table when 0 is not a good default PTE value
3) powerpc32: adds direct support to hardware inverted values in pte accessors
4) powerpc32/8xx: invert _PAGE_RW bit in PTE accessors

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

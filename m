Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbaLQJOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 04:14:37 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:50903 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaLQJOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 04:14:34 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: [PATCH v2 0/2] powerpc32: handle inverted _PAGE_RW bit outside of TLB handlers
Message-Id: <20141217091431.AD47B1A5E0F@localhost.localdomain>
Date: Wed, 17 Dec 2014 10:14:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some powerpc like the 8xx don't have a RW bit in PTE bits but a RO (Read Only) bit.
This patch implements the handling of a _PAGE_RO flag to be used in place of _PAGE_RW

Patchset:
1) powerpc32: adds handling of _PAGE_RO
2) powerpc/8xx: use _PAGE_RO instead of _PAGE_RW

All changes have been successfully tested on MPC885

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Tested-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
v2 is a complete rework compared to v1

 arch/powerpc/include/asm/pgtable-ppc32.h | 11 ++++++-----
 arch/powerpc/include/asm/pgtable.h       | 10 +++++++---
 arch/powerpc/include/asm/pte-8xx.h       |  7 +++----
 arch/powerpc/include/asm/pte-common.h    | 27 ++++++++++++++++++---------
 arch/powerpc/kernel/head_8xx.S           |  3 ---
 arch/powerpc/mm/gup.c                    |  2 ++
 arch/powerpc/mm/mem.c                    |  2 +-
 arch/powerpc/mm/pgtable_32.c             | 24 ++++++++++++++++++++----
 8 files changed, 57 insertions(+), 29 deletions(-)

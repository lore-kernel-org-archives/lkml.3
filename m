Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaH2JN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 05:13:28 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:36010 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbaH2JN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 05:13:27 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Subject: [PATCH v2 00/19] powerpc/8xx: Optimise MMU TLB handling and add support of 16k pages
Message-Id: <20140829091324.D71E61ABD63@localhost.localdomain>
Date: Fri, 29 Aug 2014 11:13:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset:
1) provides several MMU TLB handling optimisation on MPC8xx.
2) adds support of 16k pages on MPC8xx.
All changes have been successfully tested on a custom board equipped with MPC885

The two differences with first version of the patch are:
1) I removed the patch number 10, which was implementing a 16 bit alignment of the
PGDIR. It is not worth potentially wasting up to 64k of memory just for removing one
instruction (ori).
2) I managed to preserve r11 while calculating the level 2 address, therefore
no more need to save r11 into CR.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Tested-by: Christophe Leroy <christophe.leroy@c-s.fr>

 arch/powerpc/Kconfig                     |    2 +-
 arch/powerpc/include/asm/mmu-8xx.h       |    2 +
 arch/powerpc/include/asm/pgtable-ppc32.h |   21 ++
 arch/powerpc/include/asm/pte-8xx.h       |    7 +-
 arch/powerpc/include/asm/reg.h           |    3 +-
 arch/powerpc/kernel/head_8xx.S           |  342 +++++++++++-------------
 6 files changed, 187 insertions(+), 190 deletions(-)

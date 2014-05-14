Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbaENTAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:00:47 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62408 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaENTAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:00:46 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-arch@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Consolidate tlb.h
Date: Wed, 14 May 2014 20:59:32 +0200
Message-Id: <1400093999-18703-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While staring at an UML TLB bug I've noticed that most archs
copy and pasted stuff from each others tlb.h.
This patch series combines common stuff into the generic tlb.h.

[PATCH 01/27] arm64: Override defaults from generic/tlb.h
[PATCH 02/27] powerpc: Override defaults from generic/tlb.h
[PATCH 03/27] generic/tlb.h: Move common defines into generic tlb.h
[PATCH 04/27] alpha: Use generic tlb.h
[PATCH 05/27] arc: Use common bits from generic tlb.h
[PATCH 06/27] avr32: Use common bits from generic tlb.h
[PATCH 07/27] blackfin: Use generic tlb.h
[PATCH 08/27] c6x: Use generic tlb.h
[PATCH 09/27] cris: Use common bits from generic tlb.h
[PATCH 10/27] frv: Use common bits from generic tlb.h
[PATCH 11/27] hexagon: Use common bits from generic tlb.h
[PATCH 12/27] m32r: Use generic tlb.h
[PATCH 13/27] m68k: Use common bits from generic tlb.h
[PATCH 14/27] metag: Use common bits from generic tlb.h
[PATCH 15/27] microblaze: Use generic tlb.h
[PATCH 16/27] mips: Use common bits from generic tlb.h
[PATCH 17/27] mn10300: Use generic tlb.h
[PATCH 18/27] openrisc: Use generic tlb.h
[PATCH 19/27] parisc: Use common bits from generic tlb.h
[PATCH 20/27] powerpc: Use common bits from generic tlb.h
[PATCH 21/27] score: Use generic tlb.h
[PATCH 22/27] sh: Use common bits from generic tlb.h
[PATCH 23/27] sparc: Use common bits from generic tlb.h
[PATCH 24/27] tile: Use generic tlb.h
[PATCH 25/27] unicore32: Use common bits from generic tlb.h
[PATCH 26/27] x86: Use common bits from generic tlb.h
[PATCH 27/27] xtensa: Use common bits from generic tlb.h

 arch/alpha/include/asm/Kbuild      |  1 +
 arch/alpha/include/asm/tlb.h       | 15 ---------------
 arch/arc/include/asm/tlb.h         |  6 +-----
 arch/arm64/include/asm/tlb.h       |  7 +++++++
 arch/avr32/include/asm/tlb.h       |  7 -------
 arch/blackfin/include/asm/Kbuild   |  1 +
 arch/blackfin/include/asm/tlb.h    | 22 ---------------------
 arch/c6x/include/asm/Kbuild        |  1 +
 arch/c6x/include/asm/tlb.h         |  8 --------
 arch/cris/include/asm/tlb.h        | 11 -----------
 arch/frv/include/asm/tlb.h         | 12 ------------
 arch/hexagon/include/asm/Kbuild    |  1 +
 arch/hexagon/include/asm/tlb.h     | 39 --------------------------------------
 arch/m32r/include/asm/Kbuild       |  1 +
 arch/m32r/include/asm/tlb.h        | 20 -------------------
 arch/m68k/include/asm/tlb.h        | 18 +++++-------------
 arch/metag/include/asm/tlb.h       | 10 ----------
 arch/microblaze/include/asm/Kbuild |  1 +
 arch/microblaze/include/asm/tlb.h  | 25 ------------------------
 arch/mips/include/asm/tlb.h        |  7 -------
 arch/mn10300/include/asm/Kbuild    |  1 +
 arch/mn10300/include/asm/pgalloc.h |  2 ++
 arch/mn10300/include/asm/tlb.h     | 34 ---------------------------------
 arch/openrisc/include/asm/Kbuild   |  1 +
 arch/openrisc/include/asm/tlb.h    | 34 ---------------------------------
 arch/parisc/include/asm/tlb.h      |  6 ------
 arch/powerpc/include/asm/pgalloc.h |  1 -
 arch/powerpc/include/asm/tlb.h     |  7 ++++---
 arch/score/include/asm/Kbuild      |  1 +
 arch/score/include/asm/irq.h       |  1 +
 arch/score/include/asm/tlb.h       | 17 -----------------
 arch/sh/include/asm/tlb.h          |  5 -----
 arch/sparc/include/asm/tlb_32.h    |  8 --------
 arch/sparc/include/asm/tlb_64.h    |  3 ---
 arch/tile/include/asm/Kbuild       |  1 +
 arch/tile/include/asm/tlb.h        | 25 ------------------------
 arch/unicore32/include/asm/tlb.h   |  5 -----
 arch/x86/include/asm/tlb.h         |  4 ----
 arch/xtensa/include/asm/tlb.h      | 16 +---------------
 include/asm-generic/tlb.h          | 24 +++++++++++++++++++++++
 40 files changed, 55 insertions(+), 354 deletions(-)

All patches are also available at:
git://git.kernel.org/pub/scm/linux/kernel/git/rw/misc.git tlb-generic-cleanup

Thanks,
//richard

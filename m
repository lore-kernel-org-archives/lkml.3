Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab3JHFNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 01:13:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813Ab3JHFMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 01:12:41 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, Richard Henderson <rth@twiddle.net>,
        Vineet Gupta <vgupta@synopsys.com>,
        Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH v2 00/14] Kconfig cleanup (PARPORT_PC dependencies)
Date: Tue,  8 Oct 2013 01:10:16 -0400
Message-Id: <1381209030-351-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series removes the messy dependencies from PARPORT_PC
by having it depend on one symbol (ARCH_MAY_HAVE_PC_PARPORT) and
having architectures which need it, select ARCH_MAY_HAVE_PC_PARPORT
in arch/*/Kconfig.

New architectures are unlikely to need PARPORT_PC, so this avoids
having an ever growing list of architectures to exclude. Those
architectures which do select ARCH_MAY_HAVE_PC_PARPORT in this
patch are the ones which have an asm/parport.h (or use the generic
version).

V1 or this patch can be found here:

  http://www.spinics.net/lists/linux-arch/msg23167.html

V2 changes:

  * Use select instead of adding config option to arch/*/Kconfig
  * Split into multiple patches for individual architectures
  * Dropped tile architecture

Mark Salter (14):
  alpha: select ARCH_MAY_HAVE_PC_PARPORT
  arc: select ARCH_MAY_HAVE_PC_PARPORT
  arm: select ARCH_MAY_HAVE_PC_PARPORT
  ia64: select ARCH_MAY_HAVE_PC_PARPORT
  m68k: select ARCH_MAY_HAVE_PC_PARPORT
  microblaze: select ARCH_MAY_HAVE_PC_PARPORT
  mips: select ARCH_MAY_HAVE_PC_PARPORT
  parisc: select ARCH_MAY_HAVE_PC_PARPORT
  powerpc: select ARCH_MAY_HAVE_PC_PARPORT
  sh: select ARCH_MAY_HAVE_PC_PARPORT
  sparc: select ARCH_MAY_HAVE_PC_PARPORT
  unicore32: select ARCH_MAY_HAVE_PC_PARPORT
  x86: select ARCH_MAY_HAVE_PC_PARPORT
  Kconfig cleanup (PARPORT_PC dependencies)

 arch/alpha/Kconfig      |  1 +
 arch/arc/Kconfig        |  1 +
 arch/arm/Kconfig        |  1 +
 arch/ia64/Kconfig       |  1 +
 arch/m68k/Kconfig       |  1 +
 arch/microblaze/Kconfig |  1 +
 arch/mips/Kconfig       |  1 +
 arch/parisc/Kconfig     |  1 +
 arch/powerpc/Kconfig    |  1 +
 arch/sh/Kconfig         |  1 +
 arch/sparc/Kconfig      |  1 +
 arch/unicore32/Kconfig  |  1 +
 arch/x86/Kconfig        |  1 +
 drivers/parport/Kconfig | 10 +++++++---
 14 files changed, 20 insertions(+), 3 deletions(-)

-- 
1.8.3.1


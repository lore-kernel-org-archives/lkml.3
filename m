Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab3LPA5Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 19:57:24 -0500
Received: from gate.crashing.org ([63.228.1.57]:56609 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab3LPA5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 19:57:23 -0500
Message-ID: <1387155428.15730.179.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Mon, 16 Dec 2013 11:57:08 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are some more powerpc fixes for 3.13.

Uli's patch fixes a regression in ptrace caused by a mis-merge of
a previous LE patch. The rest are all more endian fixes, all fairly
trivial, found during testing of 3.13-rc's.

Cheers,
Ben.

The following changes since commit e641eb03ab2b0f065fa5e64b4202fb5b0441b427:

  powerpc: Fix up the kdump base cap to 128M (2013-12-10 11:28:39 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 803c2d2f84da9dc2619449994af34d27148ab20d:

  powerpc/powernv: Fix OPAL LPC access in Little Endian (2013-12-13 15:55:15 +1100)

----------------------------------------------------------------
Anton Blanchard (8):
      powerpc: Fix endian issue in setup-common.c
      powerpc: Fix topology core_id endian issue on LE builds
      powerpc/pseries: Fix endian issues in /proc/ppc64/lparcfg
      powerpc/pseries: Fix endian issues in nvram code
      powerpc/pseries: Fix PCIE link speed endian issue
      powerpc/pseries: Fix endian issues in MSI code
      powerpc: Fix endian issues in crash dump code
      powerpc/powernv: Fix endian issue in opal_xscom_read

Benjamin Herrenschmidt (1):
      powerpc/powernv: Fix OPAL LPC access in Little Endian

Ulrich Weigand (1):
      powerpc: PTRACE_PEEKUSR always returns FPR0

 arch/powerpc/include/asm/opal.h             |  4 +--
 arch/powerpc/kernel/crash_dump.c            |  6 ++--
 arch/powerpc/kernel/ptrace.c                |  4 +--
 arch/powerpc/kernel/setup-common.c          |  4 +--
 arch/powerpc/kernel/smp.c                   |  4 +--
 arch/powerpc/platforms/powernv/opal-lpc.c   | 12 ++++----
 arch/powerpc/platforms/powernv/opal-xscom.c |  4 ++-
 arch/powerpc/platforms/pseries/lparcfg.c    | 12 ++++----
 arch/powerpc/platforms/pseries/msi.c        | 28 ++++++++++--------
 arch/powerpc/platforms/pseries/nvram.c      | 46 ++++++++++++++---------------
 arch/powerpc/platforms/pseries/pci.c        |  8 ++---
 11 files changed, 68 insertions(+), 64 deletions(-)



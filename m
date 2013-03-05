Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab3CEGaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 01:30:20 -0500
Received: from gate.crashing.org ([63.228.1.57]:34531 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab3CEGaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 01:30:18 -0500
Message-ID: <1362465003.21357.55.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Tue, 05 Mar 2013 17:30:03 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few powerpc bits & fixes for rc1. A couple of str*cpy fixes,
some fixes in handling the FSCR register on Power8 (controls the
enabling of processor features), a 32-bit build fix and a couple more
nits.

Cheers,
Ben.

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 54c9b2253d34e8998e4bff9ac2d7a3ba0b861d52:

  powerpc: Set DSCR bit in FSCR setup (2013-03-05 16:56:30 +1100)

----------------------------------------------------------------
Akinobu Mita (1):
      powerpc: Remove unused BITOP_LE_SWIZZLE macro

Chen Gang (2):
      powerpc/pseries/hvcserver: Fix strncpy buffer limit in location code
      drivers/tty/hvc: Use strlcpy instead of strncpy

Michael Neuling (4):
      powerpc: Avoid link stack corruption in MMU on syscall entry path
      powerpc: Fix setting FSCR for HV=0 and on secondary CPUs
      powerpc: Add DSCR FSCR register bit definition
      powerpc: Set DSCR bit in FSCR setup

Tony Breeds (2):
      powerpc: Fix compile of sha1-powerpc-asm.S on 32-bit
      powerpc: Wireup the kcmp syscall to sys_ni

 arch/powerpc/crypto/sha1-powerpc-asm.S     |    4 ++--
 arch/powerpc/include/asm/bitops.h          |    2 --
 arch/powerpc/include/asm/reg.h             |    3 ++-
 arch/powerpc/include/asm/systbl.h          |    1 +
 arch/powerpc/include/asm/unistd.h          |    2 +-
 arch/powerpc/include/uapi/asm/unistd.h     |    1 +
 arch/powerpc/kernel/cpu_setup_power.S      |    5 +++--
 arch/powerpc/kernel/exceptions-64s.S       |    4 ++--
 arch/powerpc/platforms/pseries/hvcserver.c |    5 +++--
 drivers/tty/hvc/hvcs.c                     |    9 ++-------
 10 files changed, 17 insertions(+), 19 deletions(-)



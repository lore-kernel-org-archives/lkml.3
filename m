Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807Ab3GaVzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 17:55:31 -0400
Received: from mout.gmx.net ([212.227.15.18]:63841 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab3GaVza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 17:55:30 -0400
Date: Wed, 31 Jul 2013 23:55:26 +0200
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] parisc updates for v3.11-rc4
Message-ID: <20130731215526.GA5249@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:kW+OcNTu0tEg3CsBgQUHLdyNYMuolINNAemn2G5WjfFIw0Uo8zz
 nSBZU34ni2CJp1NxMNPSyNBzz6XcLy/20dKQuG+Qjg2mhw2iDUtws6jplSPOvfeMLoi/5hz
 fEUHLcbnz+lE8TCRNFLxuHK2rHK8ytmQor0b54thmXOg42LG95sP5IiEZVeOmg9QqpFk0RB
 cr/q2QhlMcKkOCh8eW9yw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the latest parisc architecture fixes from:
  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.11-rc4

The majority of lines changed are due the addition of a defconfig for the C8000
machine.  Even the fix in parisc/kernel/cache.c file is actually ony a 10-line
fix, but the change became bigger (and much nicer) to avoid errors of the
checkpatch script.

Here is the short-changelog:

This round of parisc updates includes mostly fixes for the C8000 workstation.
We have a new defconfig file for this machine, as well as fixes for it's serial
port, the AGP driver and the cache routines to cope with the vmas of the
FireGL card in a C8000.  The sys32.h header file was not used and as such it's
now gone.


Thanks,
Helge 

----------------------------------------------------------------
Alex Ivanov (1):
      parisc: agp/parisc-agp: allow binding of user memory to the AGP GART

Helge Deller (1):
      parisc: add defconfig for c8000 machine

John David Anglin (2):
      parisc: Fix cache routines to ignore vma's with an invalid pfn
      parisc: Remove arch/parisc/kernel/sys32.h header

Thomas Bogendoerfer (1):
      parisc: Fix interrupt routing for C8000 serial ports

 arch/parisc/configs/c8000_defconfig     | 279 ++++++++++++++++++++++++++++++++
 arch/parisc/include/asm/parisc-device.h |   3 +
 arch/parisc/kernel/cache.c              | 135 ++++++++--------
 arch/parisc/kernel/inventory.c          |   1 +
 arch/parisc/kernel/signal.c             |   7 -
 arch/parisc/kernel/signal32.c           |   1 -
 arch/parisc/kernel/sys32.h              |  36 -----
 arch/parisc/kernel/sys_parisc32.c       |   2 -
 drivers/char/agp/parisc-agp.c           |   6 +-
 drivers/parisc/iosapic.c                |  38 +++--
 drivers/tty/serial/8250/8250_gsc.c      |   3 +-
 11 files changed, 386 insertions(+), 125 deletions(-)
 create mode 100644 arch/parisc/configs/c8000_defconfig
 delete mode 100644 arch/parisc/kernel/sys32.h

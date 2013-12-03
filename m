Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab3LCWvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:51:41 -0500
Received: from mout.gmx.net ([212.227.15.19]:59150 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354Ab3LCWvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:51:39 -0500
Date: Tue, 3 Dec 2013 23:51:35 +0100
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] parisc updates for v3.13
Message-ID: <20131203225135.GA24347@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:+eP237a4TqKJ0qZoHsCa0CRdnqEtniLKcSepljac7hpq89FqFq5
 YgUzRWPoH94Kw4/oq0VoOTFkdM82z4d6WruODdqpU6idmln/ZE3Fk825lWsMEQHV7ddHezQ
 uXNEX6hB9SAy/fK7VMdQSHMJW3b3OhwxKBvNE6yE7eLooKd8gbln9izNAPoevy3iDzypLfS
 1X9CJ74D7hCFJEMFRMs/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the latest parisc fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.13

The major changes are:
- a fix for the mmap(MAP_FIXED|MAP_SHARED) syscall to the same address which
  was already given in a previous call (fixes locale-gen on debian)
- change the memory layout of the kernel to avoid the need for the -mlong-calls
  compiler option (depends on commit 5ecbe3c - kernel/extable: fix
  address-checks for core_kernel and init areas)
- defconfig updates, e.g. use the SIL680 driver instead of the SIIMAGE driver
- add more parisc machine names to the machine database

Thanks,
Helge

----------------------------------------------------------------
Chen Gang (1):
      parisc: remove empty SERIAL_PORT_DFNS in serial.h

Helge Deller (6):
      parisc: fix mmap(MAP_FIXED|MAP_SHARED) to already mmapped address
      parisc: add some more machine names to hardware database
      parisc: use kernel_text_address() in unwind functions
      parisc: fix kernel memory layout in vmlinux.ld.S
      parisc: remove CONFIG_MLONGCALLS=y from defconfigs
      parisc: update 64bit defconfigs and use SIL680 instead of SIIMAGE driver

 arch/parisc/configs/c3000_defconfig         |   2 +-
 arch/parisc/configs/c8000_defconfig         |  36 +-------
 arch/parisc/configs/generic-64bit_defconfig |  39 +-------
 arch/parisc/include/asm/serial.h            |   2 -
 arch/parisc/kernel/hardware.c               |   7 +-
 arch/parisc/kernel/head.S                   |   6 +-
 arch/parisc/kernel/sys_parisc.c             |  25 +++--
 arch/parisc/kernel/unwind.c                 |   9 +-
 arch/parisc/kernel/vmlinux.lds.S            | 138 ++++++++++++----------------
 arch/parisc/mm/init.c                       |  19 +++-
 10 files changed, 110 insertions(+), 173 deletions(-)

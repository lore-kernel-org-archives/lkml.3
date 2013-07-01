Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab3GADOJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 23:14:09 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47757 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752098Ab3GADOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 23:14:06 -0400
X-Sasl-enc: Zcncozmz+umXHs1Wc6shBQUaeGIb/8vAsg4AWpeiajCl 1372648444
Subject: [RFC PATCH 0/7] autofs4 - rename autofs4 to autofs
To: linux-next@vger.kernel.org
From: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 01 Jul 2013 11:14:00 +0800
Message-ID: <20130701031335.4423.6154.stgit@perseus.fritz.box>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The autofs4 kernel module provides function for autofs version 3, 4 and
5 and autofs module has long since been removed. Now we're left with a
misnamed module. Appart from the name another problem this presents is
that module autoload doesn't work because of the mismatch of the directory
name and the name of the file system provided by the module.

So autofs4 should be renamed to autofs but I've held back doing it because
of the potential disruption that could occur with a change like this.

The issues are somewhat reduced now because systemd needs the autofs
module at startup and because of the autoload issue it is easier to just
compile the module into the kernel which is what is done in some cases.

The big question for me is whether to leave a build stub in the autofs4
directory along with a warning in Kconfig that the stub will be removed
after two kernel versions or just straight out rename it and be done
with it.

The series here leaves a stub but I'd like comments thoughts on whether
to use the stub or just rename the module?

---

Ian Kent (7):
      autofs4 - coding style fixes
      autofs4 - fix string.h include in auto_dev-ioctl.h
      autofs4 - move linux/auto_dev-ioctl.h to uapi/linux
      autofs - merge auto_fs.h and auto_fs4.h
      autofs - use autofs instead of autofs4 everywhere
      autofs - rename module autofs4 to autofs
      autofs - change CONFIG_AUTOFS4_FS to CONFIG_AUTOFS_FS


 MAINTAINERS                                  |    4 
 arch/arm/configs/at91rm9200_defconfig        |    2 
 arch/arm/configs/bcm_defconfig               |    2 
 arch/arm/configs/cns3420vb_defconfig         |    2 
 arch/arm/configs/colibri_pxa270_defconfig    |    2 
 arch/arm/configs/da8xx_omapl_defconfig       |    2 
 arch/arm/configs/davinci_all_defconfig       |    2 
 arch/arm/configs/ebsa110_defconfig           |    2 
 arch/arm/configs/ezx_defconfig               |    2 
 arch/arm/configs/footbridge_defconfig        |    2 
 arch/arm/configs/imote2_defconfig            |    2 
 arch/arm/configs/imx_v6_v7_defconfig         |    2 
 arch/arm/configs/lpc32xx_defconfig           |    2 
 arch/arm/configs/mini2440_defconfig          |    2 
 arch/arm/configs/omap1_defconfig             |    2 
 arch/arm/configs/rpc_defconfig               |    2 
 arch/arm/configs/s3c2410_defconfig           |    2 
 arch/arm/configs/spear13xx_defconfig         |    2 
 arch/arm/configs/spear3xx_defconfig          |    2 
 arch/arm/configs/spear6xx_defconfig          |    2 
 arch/arm/configs/trizeps4_defconfig          |    2 
 arch/ia64/configs/bigsur_defconfig           |    2 
 arch/ia64/configs/generic_defconfig          |    2 
 arch/ia64/configs/gensparse_defconfig        |    2 
 arch/ia64/configs/tiger_defconfig            |    2 
 arch/ia64/configs/xen_domu_defconfig         |    2 
 arch/m68k/configs/amiga_defconfig            |    2 
 arch/m68k/configs/apollo_defconfig           |    2 
 arch/m68k/configs/atari_defconfig            |    2 
 arch/m68k/configs/bvme6000_defconfig         |    2 
 arch/m68k/configs/hp300_defconfig            |    2 
 arch/m68k/configs/mac_defconfig              |    2 
 arch/m68k/configs/multi_defconfig            |    2 
 arch/m68k/configs/mvme147_defconfig          |    2 
 arch/m68k/configs/mvme16x_defconfig          |    2 
 arch/m68k/configs/q40_defconfig              |    2 
 arch/m68k/configs/sun3_defconfig             |    2 
 arch/m68k/configs/sun3x_defconfig            |    2 
 arch/mips/configs/bcm47xx_defconfig          |    2 
 arch/mips/configs/bigsur_defconfig           |    2 
 arch/mips/configs/capcella_defconfig         |    2 
 arch/mips/configs/e55_defconfig              |    2 
 arch/mips/configs/fuloong2e_defconfig        |    2 
 arch/mips/configs/ip22_defconfig             |    2 
 arch/mips/configs/ip32_defconfig             |    2 
 arch/mips/configs/jazz_defconfig             |    2 
 arch/mips/configs/lemote2f_defconfig         |    2 
 arch/mips/configs/markeins_defconfig         |    2 
 arch/mips/configs/mpc30x_defconfig           |    2 
 arch/mips/configs/mtx1_defconfig             |    2 
 arch/mips/configs/nlm_xlp_defconfig          |    2 
 arch/mips/configs/nlm_xlr_defconfig          |    2 
 arch/mips/configs/rm200_defconfig            |    2 
 arch/mips/configs/tb0219_defconfig           |    2 
 arch/mips/configs/tb0226_defconfig           |    2 
 arch/mips/configs/tb0287_defconfig           |    2 
 arch/mips/configs/workpad_defconfig          |    2 
 arch/parisc/configs/712_defconfig            |    2 
 arch/parisc/configs/a500_defconfig           |    2 
 arch/parisc/configs/b180_defconfig           |    2 
 arch/parisc/configs/c3000_defconfig          |    2 
 arch/powerpc/configs/40x/virtex_defconfig    |    2 
 arch/powerpc/configs/44x/sam440ep_defconfig  |    2 
 arch/powerpc/configs/44x/virtex5_defconfig   |    2 
 arch/powerpc/configs/85xx/stx_gp3_defconfig  |    2 
 arch/powerpc/configs/86xx/sbc8641d_defconfig |    2 
 arch/powerpc/configs/c2k_defconfig           |    2 
 arch/powerpc/configs/cell_defconfig          |    2 
 arch/powerpc/configs/ep8248e_defconfig       |    2 
 arch/powerpc/configs/mgcoge_defconfig        |    2 
 arch/powerpc/configs/mpc8272_ads_defconfig   |    2 
 arch/powerpc/configs/pasemi_defconfig        |    2 
 arch/powerpc/configs/pmac32_defconfig        |    2 
 arch/powerpc/configs/ppc64_defconfig         |    2 
 arch/powerpc/configs/ppc64e_defconfig        |    2 
 arch/powerpc/configs/ppc6xx_defconfig        |    2 
 arch/powerpc/configs/pq2fads_defconfig       |    2 
 arch/powerpc/configs/ps3_defconfig           |    2 
 arch/powerpc/configs/pseries_defconfig       |    2 
 arch/score/configs/spct6600_defconfig        |    2 
 arch/sh/configs/espt_defconfig               |    2 
 arch/sh/configs/sdk7780_defconfig            |    2 
 arch/sh/configs/sdk7786_defconfig            |    2 
 arch/sh/configs/sh03_defconfig               |    2 
 arch/sh/configs/sh7763rdp_defconfig          |    2 
 arch/sparc/configs/sparc32_defconfig         |    2 
 arch/tile/configs/tilegx_defconfig           |    2 
 arch/tile/configs/tilepro_defconfig          |    2 
 arch/um/defconfig                            |    2 
 arch/x86/configs/i386_defconfig              |    2 
 arch/x86/configs/x86_64_defconfig            |    2 
 arch/xtensa/configs/common_defconfig         |    1 
 arch/xtensa/configs/iss_defconfig            |    1 
 arch/xtensa/configs/s6105_defconfig          |    1 
 fs/Kconfig                                   |    1 
 fs/Makefile                                  |    1 
 fs/autofs/Kconfig                            |   19 +
 fs/autofs/Makefile                           |    7 
 fs/autofs/autofs_i.h                         |  341 ++++++++++
 fs/autofs/dev-ioctl.c                        |  759 ++++++++++++++++++++++
 fs/autofs/expire.c                           |  561 ++++++++++++++++
 fs/autofs/init.c                             |   49 +
 fs/autofs/inode.c                            |  368 +++++++++++
 fs/autofs/root.c                             |  898 ++++++++++++++++++++++++++
 fs/autofs/symlink.c                          |   21 +
 fs/autofs/waitq.c                            |  570 +++++++++++++++++
 fs/autofs4/Kconfig                           |   31 +
 fs/autofs4/Makefile                          |   10 
 fs/autofs4/autofs_i.h                        |  341 ----------
 fs/autofs4/dev-ioctl.c                       |  760 ----------------------
 fs/autofs4/expire.c                          |  562 ----------------
 fs/autofs4/init.c                            |   52 --
 fs/autofs4/inode.c                           |  371 -----------
 fs/autofs4/root.c                            |  898 --------------------------
 fs/autofs4/symlink.c                         |   24 -
 fs/autofs4/waitq.c                           |  572 -----------------
 fs/compat_ioctl.c                            |    1 
 include/linux/auto_dev-ioctl.h               |  229 -------
 include/linux/auto_fs.h                      |    5 
 include/uapi/linux/auto_dev-ioctl.h          |  224 ++++++
 include/uapi/linux/auto_fs.h                 |  156 ++++-
 include/uapi/linux/auto_fs4.h                |  158 -----
 122 files changed, 4090 insertions(+), 4086 deletions(-)
 create mode 100644 fs/autofs/Kconfig
 create mode 100644 fs/autofs/Makefile
 create mode 100644 fs/autofs/autofs_i.h
 create mode 100644 fs/autofs/dev-ioctl.c
 create mode 100644 fs/autofs/expire.c
 create mode 100644 fs/autofs/init.c
 create mode 100644 fs/autofs/inode.c
 create mode 100644 fs/autofs/root.c
 create mode 100644 fs/autofs/symlink.c
 create mode 100644 fs/autofs/waitq.c
 delete mode 100644 fs/autofs4/autofs_i.h
 delete mode 100644 fs/autofs4/dev-ioctl.c
 delete mode 100644 fs/autofs4/expire.c
 delete mode 100644 fs/autofs4/init.c
 delete mode 100644 fs/autofs4/inode.c
 delete mode 100644 fs/autofs4/root.c
 delete mode 100644 fs/autofs4/symlink.c
 delete mode 100644 fs/autofs4/waitq.c
 delete mode 100644 include/linux/auto_dev-ioctl.h
 create mode 100644 include/uapi/linux/auto_dev-ioctl.h

-- 
Signature

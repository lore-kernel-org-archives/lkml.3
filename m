Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaIJThj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:37:39 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33705 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbaIJThh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:37:37 -0400
Date: Wed, 10 Sep 2014 12:37:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Sep 10
Message-ID: <20140910193732.GA29618@roeck-us.net>
References: <20140910185920.336180d4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140910185920.336180d4@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 06:59:20PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20140909:
> 
> New tree: powerpc-merge-mpe
> 
> The pm tree gained conflicts against the mvebu and arm-soc trees.
> 
> The v4l-dvb tree still had its build failure so I used the version from
> next-20140908.
> 
> The net-next tree gained a conflict against the arm-soc tree.
> 
> The wireless-next tree lost its build failure.
> 
> The drm tree still had its build failure for which I applied a merge
> fix patch.
> 
> The regulator tree still had its build failure for which I reverted
> several commits.
> 
> The trivial tree gained a conflict against the block tree.
> 
> The clk tree gained a conflict against the renesas tree.
> 
> The akpm-current tree lost its build failure.
> 
> Non-merge commits (relative to Linus' tree): 4389
>  4067 files changed, 140816 insertions(+), 93267 deletions(-)
> 

I see a large number of build failures.

Build results:
	total: 133 pass: 95 fail: 38
Failed builds:
	alpha:defconfig
	alpha:allmodconfig
	arm:shmobile_defconfig
	arm:bcm2835_defconfig
	arm:efm32_defconfig
	arm:clps711x_defconfig
	cris:defconfig
	cris:etrax-100lx_defconfig
	cris:artpec_3_defconfig
	cris:etraxfs_defconfig
	frv:defconfig
	hexagon:defconfig
	ia64:defconfig
	m68k:allmodconfig
	m68k:m5272c3_defconfig
	m68k:m5307c3_defconfig
	m68k:m5249evb_defconfig
	mips:allmodconfig
	mips:bcm47xx_defconfig
	mips:bcm63xx_defconfig
	mips:nlm_xlp_defconfig
	mips:ath79_defconfig
	mips:ar7_defconfig
	mips:fuloong2e_defconfig
	mips:cavium_octeon_defconfig
	mips:malta_defconfig
	mn10300:asb2303_defconfig
	parisc:defconfig
	parisc:generic-32bit_defconfig
	parisc:a500_defconfig
	parisc:generic-64bit_defconfig
	powerpc:85xx/sbc8548_defconfig
	sh:microdev_defconfig
	sparc64:allmodconfig
	unicore32:defconfig
	xtensa:defconfig
	xtensa:allmodconfig

Key build failures:

kernel/built-in.o: In function `irq_work_sync':
(.text+0x2cfd8): undefined reference to `module_alloc'
kernel/built-in.o: In function `irq_work_sync':
(.text+0x2cfe0): undefined reference to `module_free'

This is seen for several architectures and drivers.

---
drivers/tty/serial/8250/8250_core.c: In function ‘serial8250_ioctl’:
drivers/tty/serial/8250/8250_core.c:2874:7: error:
		‘TIOCSRS485’ undeclared (first use in this function)
drivers/tty/serial/8250/8250_core.c:2886:7: error:
		‘TIOCGRS485’ undeclared (first use in this function)

Seen for several architectures. For some of the affected architectures
I have seen patches on lkml, others such as alpha are still unpatched
as far as I can see.

---
For sparc64, we also have

In file included from drivers/tty/serial/serial_mctrl_gpio.c:21:0:
include/uapi/asm-generic/termios.h:22:8: error:
		redefinition of 'struct termio'
./arch/sparc/include/uapi/asm/termbits.h:16:8: note:
		originally defined here

I didn't bother trying runtime tests.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter

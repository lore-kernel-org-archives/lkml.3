Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbaLQU6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 15:58:53 -0500
Received: from smtprelay0087.hostedemail.com ([216.40.44.87]:60797 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750999AbaLQU6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 15:58:51 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1373:1431:1437:1515:1516:1518:1535:1544:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2904:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3870:3871:3872:4250:4605:5007:6119:6261:7875:7903:7904:8660:10004:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:13148:13161:13229:13230:21063:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fang92_872cb68b11256
X-Filterd-Recvd-Size: 5562
Message-ID: <1418849927.28384.1.camel@perches.com>
Subject: rfc: remove early_printk from a few arches? (blackfin, m68k, mips)
From: Joe Perches <joe@perches.com>
To: linux-arch <linux-arch@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        Steven Miao <realmz6@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips <linux-mips@linux-mips.org>
Date: Wed, 17 Dec 2014 12:58:47 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems like early_printk can be configured into
a few architectures but also appear not to be used.

$ git grep -w "early_printk"
arch/arm/kernel/Makefile:obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
arch/arm/kernel/early_printk.c: *  linux/arch/arm/kernel/early_printk.c
arch/arm/mach-socfpga/socfpga.c:	early_printk("Early printk initialized\n");
arch/blackfin/kernel/Makefile:obj-$(CONFIG_EARLY_PRINTK)           += early_printk.o
arch/blackfin/kernel/bfin_dma.c:#include <asm/early_printk.h>
arch/blackfin/kernel/early_printk.c: * derived from arch/x86/kernel/early_printk.c
arch/blackfin/kernel/early_printk.c:#include <asm/early_printk.h>
arch/blackfin/kernel/setup.c:#include <asm/early_printk.h>
arch/blackfin/kernel/shadow_console.c:#include <asm/early_printk.h>
arch/blackfin/mm/init.c:#include <asm/early_printk.h>
arch/ia64/sn/kernel/setup.c:	 * IO on SN2 is done via SAL calls, early_printk won't work without this.
arch/m68k/kernel/Makefile:obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
arch/microblaze/kernel/Makefile:obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c:	early_printk("ERROR: Microblaze " x "-different for PVR and DTS\n");
arch/microblaze/kernel/cpu/cpuinfo-static.c:	early_printk("ERROR: Microblaze " x "-different for kernel and DTS\n");
arch/microblaze/kernel/setup.c:/* initialize device tree for usage in early_printk */
arch/mips/ath25/Makefile:obj-$(CONFIG_EARLY_PRINTK) += early_printk.o
arch/mips/ath79/Makefile:obj-$(CONFIG_EARLY_PRINTK)		+= early_printk.o
arch/mips/bcm63xx/Makefile:obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
arch/mips/include/asm/mach-lantiq/falcon/lantiq_soc.h: * during early_printk no ioremap possible at this early stage
arch/mips/include/asm/mach-lantiq/xway/lantiq_soc.h: * during early_printk no ioremap is possible
arch/mips/kernel/Makefile:obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
arch/mips/lantiq/Makefile:obj-$(CONFIG_EARLY_PRINTK) += early_printk.o
arch/mips/loongson/common/Makefile:obj-$(CONFIG_EARLY_PRINTK) += early_printk.o
arch/mips/ralink/Makefile:obj-$(CONFIG_EARLY_PRINTK) += early_printk.o
arch/tile/kernel/Makefile:obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
arch/tile/kernel/early_printk.c:	early_printk("Kernel panic - not syncing: %pV", &vaf);
arch/um/kernel/Makefile:obj-$(CONFIG_EARLY_PRINTK) += early_printk.o
arch/unicore32/kernel/Makefile:obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
arch/unicore32/kernel/early_printk.c: * linux/arch/unicore32/kernel/early_printk.c
arch/x86/kernel/Makefile:obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
arch/x86/kernel/e820.c:	early_printk(msg);
arch/x86/kernel/head64.c:		early_printk("Kernel alive\n");
arch/x86/kernel/head_64.S:	call early_printk
arch/x86/platform/efi/Makefile:obj-$(CONFIG_EARLY_PRINTK_EFI)	+= early_printk.o
drivers/tty/serial/8250/8250_early.c: * and on early_printk.c by Andi Kleen.
drivers/tty/serial/sn_console.c: * synchronous (raw) and asynchronous (buffered).  initially, early_printk
drivers/tty/serial/sn_console.c:	/* without early_printk, we may be invoked late enough to race
drivers/tty/serial/sn_console.c:	/* early_printk invocation may have done this for us */
include/linux/printk.h:void early_printk(const char *fmt, ...);
include/linux/printk.h:void early_printk(const char *s, ...) { }
kernel/events/core.c:		early_printk("perf interrupt took too long (%lld > %lld), lowering "
kernel/locking/lockdep.c: * We cannot printk in early bootup code. Not even early_printk()
kernel/printk/printk.c:asmlinkage __visible void early_printk(const char *fmt, ...)
kernel/printk/printk.c: * early_printk) - sometimes before setup_arch() completes - be careful
kernel/printk/printk.c: * There are two types of consoles - bootconsoles (early_printk) and

These seem to the only uses:

arch/arm/mach-socfpga/socfpga.c:	early_printk("Early printk initialized\n");
[]
arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c:	early_printk("ERROR: Microblaze " x "-different for PVR and DTS\n");
arch/microblaze/kernel/cpu/cpuinfo-static.c:	early_printk("ERROR: Microblaze " x "-different for kernel and DTS\n");
[]
arch/tile/kernel/early_printk.c:	early_printk("Kernel panic - not syncing: %pV", &vaf);
[]
arch/x86/kernel/e820.c:	early_printk(msg);
arch/x86/kernel/head64.c:		early_printk("Kernel alive\n");
arch/x86/kernel/head_64.S:	call early_printk
[]
kernel/events/core.c:		early_printk("perf interrupt took too long (%lld > %lld), lowering "

So blackfin, m68k, and mips seems to have it possible to enable,
but also don't appear at first glance to use it,

Is early_printk really used by these architectures?
Should it be removed?



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab3C1JY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 05:24:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:40008 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab3C1JYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 05:24:55 -0400
Date: Thu, 28 Mar 2013 10:24:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Zankel <chris@zankel.net>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: Re: [patch 00/34] idle: Consolidate idle implementations
In-Reply-To: <5153EC43.7070808@zankel.net>
Message-ID: <alpine.LFD.2.02.1303281023020.22263@ionos>
References: <20130321214930.752934102@linutronix.de> <alpine.LFD.2.02.1303271940150.22263@ionos> <5153EC43.7070808@zankel.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Mar 2013, Chris Zankel wrote:

> For Xtensa:
> Acked-by: Chris Zankel <chris@zankel.net>
> 
> Thanks for going the extra mile and test-compiling it.

Though, the build fails later with:

arch/xtensa/kernel/built-in.o:(.init.literal+0x90): undefined reference to `platform_pcibios_init'
arch/xtensa/kernel/built-in.o: In function `setup_arch':
(.init.text+0x1de): undefined reference to `platform_pcibios_init'
drivers/built-in.o: In function `pci_assign_unassigned_resources':
(.init.text+0x52b): dangerous relocation: call8: call target out of range: (.ref.text+0x3ac)
drivers/built-in.o: In function `pci_assign_unassigned_resources':
(.init.text+0x5b5): dangerous relocation: call8: call target out of range: (.ref.text+0x2c8)
drivers/built-in.o: In function `sysrq_init':
sysrq.c:(.init.text+0xb61): dangerous relocation: call8: call target out of range: panic
drivers/built-in.o: In function `console_map_init':
(.init.text+0xc97): dangerous relocation: call8: call target out of range: printk
drivers/built-in.o: In function `vtconsole_class_init':
vt.c:(.init.text+0xcdd): dangerous relocation: call8: call target out of range: printk
drivers/built-in.o: In function `con_init':
vt.c:(.init.text+0xe75): dangerous relocation: call8: call target out of range: printk
vt.c:(.init.text+0xece): dangerous relocation: call8: call target out of range: panic
drivers/built-in.o: In function `vty_init':
(.init.text+0xf32): dangerous relocation: call8: call target out of range: panic
drivers/built-in.o: In function `vty_init':
(.init.text+0xf8e): dangerous relocation: call8: call target out of range: panic
drivers/built-in.o: In function `serial8250_isa_init_ports':
8250.c:(.init.text+0x10ea): dangerous relocation: call8: call target out of range: printk
drivers/built-in.o: In function `setup_early_serial8250_console':
(.init.text+0x1450): dangerous relocation: call8: call target out of range: printk
drivers/built-in.o: In function `setup_early_serial8250_console':
(.init.text+0x1456): dangerous relocation: call8: call target out of range: panic
drivers/built-in.o: In function `setup_early_serial8250_console':
(.init.text+0x1461): dangerous relocation: call8: call target out of range: printk
drivers/built-in.o: In function `setup_early_serial8250_console':
(.init.text+0x155d): dangerous relocation: call8: call target out of range: printk
drivers/built-in.o: In function `setup_early_serial8250_console':
(.init.text+0x156e): dangerous relocation: call8: call target out of range: printk
drivers/built-in.o: In function `setup_early_serial8250_console':
(.init.text+0x1625): dangerous relocation: call8: call target out of range: printk
drivers/built-in.o: In function `chr_dev_init':
mem.c:(.init.text+0x16e6): dangerous relocation: call8: call target out of range: printk
drivers/built-in.o: In function `random_int_secret_init':
random.c:(.init.text+0x171a): dangerous relocation: call8: call target out of range: printk
drivers/built-in.o: In function `misc_init':
misc.c:(.init.text+0x1765): dangerous relocation: call8: call target out of range: printk
misc.c:(.init.text+0x1789): dangerous relocation: call8: call target out of range: printk
net/built-in.o: In function `synchronize_net':
(.text+0xc650): dangerous relocation: call8: misaligned call target: (.text.unlikely+0x43)
net/built-in.o: In function `alloc_netdev_mqs':
(.text+0xc7ed): dangerous relocation: call8: misaligned call target: (.text.unlikely+0x43)
net/built-in.o: In function `netlink_proto_init':
af_netlink.c:(.init.text+0x7a9): dangerous relocation: call8: call target out of range: (.text.unlikely+0xa4)
make[1]: *** [vmlinux] Error 1

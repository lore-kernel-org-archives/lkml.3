Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaBETJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 14:09:27 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:56029 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBETJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 14:09:24 -0500
Date: Wed, 5 Feb 2014 11:09:24 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Build regressions/improvements in v3.14-rc1
Message-ID: <20140205190924.GA24360@roeck-us.net>
References: <1391504269-6957-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391504269-6957-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 09:57:49AM +0100, Geert Uytterhoeven wrote:
> Below is the list of build error/warning regressions/improvements in
> v3.14-rc1[1] compared to v3.13[2].
> 
[ ... ]
> *** ERRORS ***
> 
> 9 regressions:
>   + /scratch/kisskb/src/arch/powerpc/kernel/exceptions-64s.S: Error: attempt to move .org backwards:  => 1312
>   + /scratch/kisskb/src/drivers/gpio/gpio-xtensa.c: error: implicit declaration of function 'RSR_CPENABLE' [-Werror=implicit-function-declaration]:  => 48:2
>   + /scratch/kisskb/src/drivers/gpio/gpio-xtensa.c: error: implicit declaration of function 'WSR_CPENABLE' [-Werror=implicit-function-declaration]:  => 49:2
>   + /scratch/kisskb/src/drivers/staging/android/ion/ion_dummy_driver.c: error: implicit declaration of function 'virt_to_phys' [-Werror=implicit-function-declaration]:  => 81:7
>   + /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: error: 'ffsusb_func' undeclared (first use in this function):  => 2688:1
>   + /scratch/kisskb/src/include/linux/omap-dma.h: error: expected identifier before numeric constant: 171:8 => 168:6, 171:8
>   + error: "irq_to_desc" [drivers/gpio/gpio-mcp23s08.ko] undefined!:  => N/A

[ affects sparc64:allmodconfig ]

>   + error: No rule to make target include/config/auto.conf:  => N/A
>   + error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+bc8:  => (.text+0x9c2)
> 

Also:

All c6x builds:

arch/c6x/include/asm/cache.h:63:20: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'c6x_cache_init' extern void __init c6x_cache_init(void);

---

mips:nlm_xlp_defconfig:

ERROR: "crc32c" [fs/btrfs/btrfs.ko] undefined!

---

powerpc:allmodconfig:
--------------
arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
arch/powerpc/kernel/exceptions-64s.S:1312: Error: attempt to move .org backwards

---

In addition to this, my sparc64 qemu test freezes, and my microblaze qemu test
crashes.

Details at http://server.roeck-us.net:8010/builders.

Guenter


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaKQI12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 03:27:28 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:56285 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaKQI11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 03:27:27 -0500
Date: Mon, 17 Nov 2014 09:27:24 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Junjie Mao <eternal.n08@gmail.com>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20141117082724.GA344@x4>
References: <20141116090743.GA19172@gmail.com>
 <20141117074247.GB340@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117074247.GB340@x4>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.11.17 at 08:42 +0100, Markus Trippelsdorf wrote:
> On 2014.11.16 at 10:07 +0100, Ingo Molnar wrote:
> > 
> > Junjie Mao (1):
> >       x86, kaslr: Prevent .bss from overlaping initrd
> 
> This breaks the build for me:
> ...
>   OBJCOPY arch/x86/boot/compressed/vmlinux.bin
>   HOSTCC  arch/x86/boot/compressed/mkpiggy
>   CC      arch/x86/boot/compressed/cpuflags.o
>   CC      arch/x86/boot/version.o
>   CC      arch/x86/boot/video-vga.o
>   CC      arch/x86/boot/video-vesa.o
>   CC      arch/x86/boot/video-bios.o
>   LZ4     arch/x86/boot/compressed/vmlinux.bin.lz4
>   HOSTCC  arch/x86/boot/tools/build
>   CPUSTR  arch/x86/boot/cpustr.h
>   CC      arch/x86/boot/cpu.o
> .bss and .brk lack common file offset
> .bss and .brk lack common file offset
> .bss and .brk lack common file offset
> .bss and .brk lack common file offset
>   MKPIGGY arch/x86/boot/compressed/piggy.S
> Usage: arch/x86/boot/compressed/mkpiggy compressed_file run_size
> arch/x86/boot/compressed/Makefile:86: recipe for target 'arch/x86/boot/compressed/piggy.S' failed

from my config: 
# CONFIG_BLK_DEV_INITRD is not set

So only running calc_run_size.pl when CONFIG_BLK_DEV_INITRD is set would
probably fix the issue.  

-- 
Markus

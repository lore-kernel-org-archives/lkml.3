Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaKQN7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:59:05 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46872 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbaKQN7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:59:00 -0500
Date: Mon, 17 Nov 2014 14:58:54 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>, eternal.n08@gmail.com,
        Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Junjie Mao <eternal.n08@gmail.com>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20141117135854.GA15076@gmail.com>
References: <20141116090743.GA19172@gmail.com>
 <20141117074247.GB340@x4>
 <20141117082724.GA344@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117082724.GA344@x4>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Markus Trippelsdorf <markus@trippelsdorf.de> wrote:

> On 2014.11.17 at 08:42 +0100, Markus Trippelsdorf wrote:
> > On 2014.11.16 at 10:07 +0100, Ingo Molnar wrote:
> > > 
> > > Junjie Mao (1):
> > >       x86, kaslr: Prevent .bss from overlaping initrd
> > 
> > This breaks the build for me:
> > ...
> >   OBJCOPY arch/x86/boot/compressed/vmlinux.bin
> >   HOSTCC  arch/x86/boot/compressed/mkpiggy
> >   CC      arch/x86/boot/compressed/cpuflags.o
> >   CC      arch/x86/boot/version.o
> >   CC      arch/x86/boot/video-vga.o
> >   CC      arch/x86/boot/video-vesa.o
> >   CC      arch/x86/boot/video-bios.o
> >   LZ4     arch/x86/boot/compressed/vmlinux.bin.lz4
> >   HOSTCC  arch/x86/boot/tools/build
> >   CPUSTR  arch/x86/boot/cpustr.h
> >   CC      arch/x86/boot/cpu.o
> > .bss and .brk lack common file offset
> > .bss and .brk lack common file offset
> > .bss and .brk lack common file offset
> > .bss and .brk lack common file offset
> >   MKPIGGY arch/x86/boot/compressed/piggy.S
> > Usage: arch/x86/boot/compressed/mkpiggy compressed_file run_size
> > arch/x86/boot/compressed/Makefile:86: recipe for target 'arch/x86/boot/compressed/piggy.S' failed

Oops ...

> from my config: 
> # CONFIG_BLK_DEV_INITRD is not set
> 
> So only running calc_run_size.pl when CONFIG_BLK_DEV_INITRD is set would
> probably fix the issue.  

I've Cc:-ed Junjie Mao and Kees Cook as well.

Thanks,

	Ingo

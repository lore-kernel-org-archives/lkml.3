Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab3FZX3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 19:29:47 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59341 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab3FZX3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 19:29:45 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 26 Jun 2013 16:29:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Ungerer <gerg@uclinux.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org
Subject: Re: [ 00/17] 3.0.84-stable review
Message-ID: <20130626232951.GA9629@roeck-us.net>
References: <20130625183915.443950649@linuxfoundation.org>
 <20130625192300.GA10427@roeck-us.net>
 <CAMuHMdVzqOLTVWHeGEFpkpDTt8hpor9zQpnn4bPDaNEGWnb=SQ@mail.gmail.com>
 <20130625193951.GF15184@roeck-us.net>
 <CAMuHMdWK9xorBaTH+Zg9z1XU=JMsSffzGEfv5KHXnMZLX04PCw@mail.gmail.com>
 <51CB73E3.9000309@uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51CB73E3.9000309@uclinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 09:06:11AM +1000, Greg Ungerer wrote:
> On 26/06/13 17:34, Geert Uytterhoeven wrote:
> >On Tue, Jun 25, 2013 at 9:39 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> >>On Tue, Jun 25, 2013 at 09:32:26PM +0200, Geert Uytterhoeven wrote:
> >>>Hi Günther,
> >>>
> >>>On Tue, Jun 25, 2013 at 9:23 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> >>>>Build m68k:defconfig passed
> >>>>Build m68k:apollo_defconfig passed
> >>>>Build m68k:m5272c3_defconfig failed
> >>>>Build m68k:m5307c3_defconfig failed
> >>>>Build m68k:m5249evb_defconfig failed
> >>>>Build m68k:m5407c3_defconfig failed
> >>>>Build m68k:mac_defconfig passed
> >>>>Build m68k:multi_defconfig passed
> >>>>Build m68k:sun3_defconfig passed
> >>>>Build m68k:sun3x_defconfig passed
> >>>>Build m68k:mvme16x_defconfig passed
> >>>>Build m68k:hp300_defconfig passed
> >>>
> >>>m68k:defconfig is an alias for m68k:multi_defconfig, so you can drop
> >>>one of them.
> >>>
> >>>Furthermore, m68k:multi_defconfig is the union of all m68k "classic MMU"
> >>>defconfigs, except for sun3_defconfig (due to the incompatible MMU type).
> >>>Hence dropping apollo_defconfig, mac_defconfig, sun3x_defconfig,
> >>>mvme16x_defconfig, and hp300_defconfig would reduce your build coverage
> >>>only marginally. Of course, if you have too many spare cycles ;-)
> >>>
> >>Thanks, I'll do that. The complete build for three releases takes 15+ hours
> >>with i7-3700k, so reducing that a bit doesn't hurt.
> >
> >FYI, you still built m68k:mvme16x_defconfig for v3.9.7-95-g6a2f14b.
> >
> >>Would there be any useful builds to add ?
> >
> >You could add m68k:m5475evb_defconfig, which is the only Coldfire
> >defconfig with MMU=y.
> >
> >Greg: Any other advice for Coldfire?
> 
> I might have some, except I am not sure what we are talking about.
> I don't have enough context from the above alone :-)
> 
Just trying to figure out an optimal set of targets for test builds.

> I take it this is test building 3.0.84?

Yes

> I haven't built a 3.0.x for a while, so not sure why the above
> ColdFire targets are failing without going and trying it out.
> 
Lots of assembler error messages, plus complaints about redefinitions and
implicit declarations.

arch/m68k/platform/coldfire/entry.S: Assembler messages:
arch/m68k/platform/coldfire/entry.S:64: Error: Unknown operator -- statement `save_all' ignored
arch/m68k/platform/coldfire/entry.S:91: Error: operands mismatch -- statement `moveml %a3-%a6/%d6-%d7,%sp@-' ignored
arch/m68k/platform/coldfire/entry.S:143: Error: Unknown operator -- statement `restore_user' ignored
arch/m68k/platform/coldfire/entry.S:192: Error: Unknown operator -- statement `rdusp' ignored
arch/m68k/platform/coldfire/entry.S:201: Error: Unknown operator -- statement `wrusp' ignored
In file included from arch/m68k/mm/init.c:4:0:
arch/m68k/mm/init_no.c:45:15: error: conflicting types for ‘empty_zero_page’
/home/groeck/src/linux-stable/arch/m68k/include/asm/pgtable_mm.h:92:14: note: previous declaration of ‘empty_zero_page’ was here
arch/m68k/kernel/setup_no.c: In function 'setup_arch':
arch/m68k/kernel/setup_no.c:264:2: error: implicit declaration of function 'paging_init' [-Werror=implicit-function-declaration]
/tmp/ccjVitY8.s:120: Error: invalid instruction for this architecture; needs 68010 or higher (68010, 68020 [68k, 68ec020], 68030 [68ec030], 68040 [68ec040], 68060 [68ec060], cpu32 [68330, 68331, 68332, 68333, 68334, 68336, 68340, 68341, 68349, 68360], fidoa [fido]) -- statement `moves.l %d1,(%a2)' ignored

and so on. Not that it tells me anything. I'd guess I have the wrong compiler, but it does
build for 3.9, so maybe not. If you have an insight, please let me know.

gcc version is 4.6.3 from kernel.org:

Using built-in specs.
COLLECT_GCC=/opt/kernel/gcc-4.6.3-nolibc/m68k-linux/bin/m68k-linux-gcc
COLLECT_LTO_WRAPPER=/opt/kernel/gcc-4.6.3-nolibc/m68k-linux/bin/../libexec/gcc/m68k-linux/4.6.3/lto-wrapper
Target: m68k-linux
Configured with: /home/tony/buildall/src/gcc/configure --target=m68k-linux
--host=x86_64-linux-gnu --build=x86_64-linux-gnu --enable-targets=all
--prefix=/opt/cross/gcc-4.6.3-nolibc/m68k-linux/ --enable-languages=c
--with-newlib --without-headers --enable-sjlj-exceptions --with-system-libunwind
--disable-nls --disable-threads --disable-shared --disable-libmudflap
--disable-libssp --disable-libgomp --disable-decimal-float
--enable-checking=release --with-mpfr=/home/tony/buildall/src/sys-x86_64
--with-gmp=/home/tony/buildall/src/sys-x86_64 --disable-bootstrap
--disable-libquadmath
Thread model: single
gcc version 4.6.3 (GCC)

Guenter

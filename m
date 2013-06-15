Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab3FOX7K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 19:59:10 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:61516 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab3FOX7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 19:59:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAHnt0GUrw+XznoUaJ31YO9yoB7JZmpbo+oAXUPud3HK-LiEiAA@mail.gmail.com>
References: <CAHnt0GUrw+XznoUaJ31YO9yoB7JZmpbo+oAXUPud3HK-LiEiAA@mail.gmail.com>
Date: Sun, 16 Jun 2013 07:59:07 +0800
Message-ID: <CAHnt0GVF9riKWGCwHJGUDQEEUq8EziRVt2nKTcjDFERvzGbzYg@mail.gmail.com>
Subject: Re: PPC440GX (taishan config) compilation errors
From: Peter Teoh <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, it is a toolchain bug.   Instead of using the one from ELDK,
now I used the

http://download.ronetix.info/toolchains/powerpc/powerpc-eabi-4.3.3.tar.bz2

and everything went smoothly.   Thanks.

On Sat, Jun 15, 2013 at 3:14 PM, Peter Teoh <htmldeveloper@gmail.com> wrote:
>
> Compiling the latest linus-git image for PPC440GX (taishan config) I
> got the following errors:
>
> git describe
> v3.10-rc5-219-ga2648eb
>
> Issuing "make V=1 ARCH=powerpc CROSS_COMPILE=ppc_4xx- oldconfig" where
> the config file ".config" is from powerpc/configs/44x gives:
>
> make -f scripts/Makefile.build obj=net/wireless
> make -f scripts/Makefile.build obj=lib
> make -f scripts/Makefile.build obj=lib/zlib_inflate
> make ARCH=ppc64 -f scripts/Makefile.build obj=arch/powerpc/boot
> arch/powerpc/boot/uImage
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
> mkdir -p arch/powerpc/boot/
>   ppc_4xx-gcc -m32 -Wp,-MD,arch/powerpc/boot/.treeboot-currituck.o.d
> -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing
> -Os -msoft-float -pipe -fomit-frame-pointer -fno-builtin -fPIC
> -nostdinc -isystem
> /opt/eldk-4.2/usr/bin/../lib/gcc/powerpc-linux/4.2.2/include
> -fno-stack-protector -Iarch/powerpc/boot
>
> -I/media/d4fdcf1c-c7f1-419a-8418-3d0e7b1ad883/linux_latest/arch/powerpc/boot
> -mcpu=405 -c -o arch/powerpc/boot/treeboot-currituck.o
> arch/powerpc/boot/treeboot-currituck.c
> {standard input}: Assembler messages:
> {standard input}:82: Error: Unrecognized opcode: `mfdcrx'
> make[1]: *** [arch/powerpc/boot/treeboot-currituck.o] Error 1
> make: *** [uImage] Error 2
>
> Question:
>
> a.   why is the "mkdir -p arch/powerpc/boot/" repeated so many times?
> b.   what is the cause of error "mfdcrx"?
>
> Any idea what is the cause of error?
>
>
> --
> Regards,
> Peter Teoh




--
Regards,
Peter Teoh

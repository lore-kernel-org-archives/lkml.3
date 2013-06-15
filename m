Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab3FOJdN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 05:33:13 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:65135 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753057Ab3FOJdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 05:33:11 -0400
Message-ID: <1371288789.16168.5.camel@x61.thuisdomein>
Subject: Re: PPC440GX (taishan config) compilation errors
From: Paul Bolle <pebolle@tiscali.nl>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 15 Jun 2013 11:33:09 +0200
In-Reply-To: <CAHnt0GUrw+XznoUaJ31YO9yoB7JZmpbo+oAXUPud3HK-LiEiAA@mail.gmail.com>
References: <CAHnt0GUrw+XznoUaJ31YO9yoB7JZmpbo+oAXUPud3HK-LiEiAA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jun 2013 09:33:09.0503 (UTC) FILETIME=[591278F0:01CE69AB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-15 at 15:14 +0800, Peter Teoh wrote:
> Compiling the latest linus-git image for PPC440GX (taishan config) I
> got the following errors:
> 
> git describe
> v3.10-rc5-219-ga2648eb
> 
> Issuing "make V=1 ARCH=powerpc CROSS_COMPILE=ppc_4xx- oldconfig" where

I don't think CROSS_COMPILE is needed at the "make oldconfig" stage.

> the config file ".config" is from powerpc/configs/44x gives:
> 
> make -f scripts/Makefile.build obj=net/wireless
> make -f scripts/Makefile.build obj=lib
> make -f scripts/Makefile.build obj=lib/zlib_inflate
> make ARCH=ppc64 -f scripts/Makefile.build obj=arch/powerpc/boot

Is this found in the output from "make V=1 ARCH=powerpc
CROSS_COMPILE=ppc_4xx- oldconfig"?

> arch/powerpc/boot/uImage
> mkdir -p arch/powerpc/boot/
>[...]
> mkdir -p arch/powerpc/boot/
>   ppc_4xx-gcc -m32 -Wp,-MD,arch/powerpc/boot/.treeboot-currituck.o.d
> -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing
> -Os -msoft-float -pipe -fomit-frame-pointer -fno-builtin -fPIC
> -nostdinc -isystem
> /opt/eldk-4.2/usr/bin/../lib/gcc/powerpc-linux/4.2.2/include
> -fno-stack-protector -Iarch/powerpc/boot
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


Paul Bolle


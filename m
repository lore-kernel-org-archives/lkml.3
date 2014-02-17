Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaBQJuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:50:51 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:35473 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaBQJut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:50:49 -0500
Date: Mon, 17 Feb 2014 10:50:48 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: hskinnemoen@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: avr32: Makefile: add '-D__linux__' flag for
 gcc-4.4.7 using.
Message-ID: <20140217095048.GA20665@samfundet.no>
References: <52ECEA2A.8070307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <52ECEA2A.8070307@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Sat 01 Feb 2014 20:35:54 +0800 or thereabout, Chen Gang wrote:
> For avr32 cross compiler, do not define '__linux__' internally, so it
> will cause issue with allmodconfig.
> 
> The related error:
> 
>     CC [M]  fs/coda/psdev.o
>   In file included from include/linux/coda.h:64,
>                    from fs/coda/psdev.c:45:
>   include/uapi/linux/coda.h:221: error: expected specifier-qualifier-list before 'u_quad_t'
> 
> The related toolchain version (which only download, not re-compile):
> 
>   [root@gchen linux-next]# /upstream/toolchain/download/avr32-gnu-toolchain-linux_x86/bin/avr32-gcc -v
>   Using built-in specs.
>   Target: avr32
>   Configured with: /data2/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/src/gcc/configure --target=avr32 --host=i686-pc-linux-gnu --build=x86_64-pc-linux-gnu --prefix=/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/avr32-gnu-toolchain-linux_x86 --enable-languages=c,c++ --disable-nls --disable-libssp --disable-libstdcxx-pch --with-dwarf2 --enable-version-specific-runtime-libs --disable-shared --enable-doc --with-mpfr-lib=/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/avr32-gnu-toolchain-linux_x86/lib --with-mpfr-include=/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/avr32-gnu-toolchain-linux_x86/include --with-gmp=/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/avr32-gnu-toolchain-linux_x86 --with-mpc=/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/avr32-gnu-toolchain-linux_x86 --enable-__cxa_atexit --disable-shared --with-newlib --with-pkgversion=AVR_32_bit_GNU_Toolchain_3.4.2_435 --with-bugurl=http://www
> .atmel.com/avr
>   Thread model: single
>   gcc version 4.4.7 (AVR_32_bit_GNU_Toolchain_3.4.2_435) 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

I will merge this into the avr32 tree in the for-linus branch. AFAICT this is
also suitable for stable, so I'll add the appropriate CC.

> ---
>  arch/avr32/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/avr32/Makefile b/arch/avr32/Makefile
> index 22fb665..dba48a5 100644
> --- a/arch/avr32/Makefile
> +++ b/arch/avr32/Makefile
> @@ -11,7 +11,7 @@ all: uImage vmlinux.elf
>  
>  KBUILD_DEFCONFIG	:= atstk1002_defconfig
>  
> -KBUILD_CFLAGS	+= -pipe -fno-builtin -mno-pic
> +KBUILD_CFLAGS	+= -pipe -fno-builtin -mno-pic -D__linux__
>  KBUILD_AFLAGS	+= -mrelax -mno-pic
>  KBUILD_CFLAGS_MODULE += -mno-relax
>  LDFLAGS_vmlinux	+= --relax
-- 
mvh
Hans-Christian Egtvedt

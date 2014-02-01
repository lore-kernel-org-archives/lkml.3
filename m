Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066AbaBAM43 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 07:56:29 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:54784 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383AbaBAM42 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 07:56:28 -0500
MIME-Version: 1.0
In-Reply-To: <52ECEA2A.8070307@gmail.com>
References: <52ECEA2A.8070307@gmail.com>
Date: Sat, 1 Feb 2014 13:56:27 +0100
Message-ID: <CAFLxGvyEx4NJ-pT4EXT_e6NaFxAwpfpAGL=CPm0o_SM96twaLg@mail.gmail.com>
Subject: Re: [PATCH] arch: avr32: Makefile: add '-D__linux__' flag for
 gcc-4.4.7 using.
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: hskinnemoen@gmail.com, egtvedt@samfundet.no,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 1, 2014 at 1:35 PM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
> For avr32 cross compiler, do not define '__linux__' internally, so it
> will cause issue with allmodconfig.

Isn't this a toolchain bug?

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
>
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
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
>  KBUILD_DEFCONFIG       := atstk1002_defconfig
>
> -KBUILD_CFLAGS  += -pipe -fno-builtin -mno-pic
> +KBUILD_CFLAGS  += -pipe -fno-builtin -mno-pic -D__linux__
>  KBUILD_AFLAGS  += -mrelax -mno-pic
>  KBUILD_CFLAGS_MODULE += -mno-relax
>  LDFLAGS_vmlinux        += --relax
> --
> 1.7.11.7
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard

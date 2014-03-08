Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaCHOCi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 09:02:38 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:40722 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaCHOCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 09:02:34 -0500
Message-ID: <531B230E.7050809@gmail.com>
Date: Sat, 08 Mar 2014 22:02:54 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Luis Henriques <luis.henriques@canonical.com>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: Re: [PATCH 3.11 042/131] avr32: Makefile: add '-D__linux__' flag
 for gcc-4.4.7 use
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com> <1394029455-23128-43-git-send-email-luis.henriques@canonical.com>
In-Reply-To: <1394029455-23128-43-git-send-email-luis.henriques@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks.

I generated "avr32-linux-" cross compiler, and will use it to compile
kernel again, and try to let it pass allmodconfig (originally, I use
"avr32-" to compile kernel, which has generated various another issues).

Thanks.

On 03/05/2014 10:22 PM, Luis Henriques wrote:
> 3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Chen Gang <gang.chen.5i5j@gmail.com>
> 
> commit 8d80390cfc9434d5aa4fb9e5f9768a66b30cb8a6 upstream.
> 
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
>   Configured with: /data2/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/src/gcc/configure --target=avr32 --host=i686-pc-linux-gnu --build=x86_64-pc-linux-gnu --prefix=/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/avr32-gnu-toolchain-linux_x86 --enable-languages=c,c++ --disable-nls --disable-libssp --disable-libstdcxx-pch --with-dwarf2 --enable-version-specific-runtime-libs --disable-shared --enable-doc --with-mpfr-lib=/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/avr32-gnu-toolchain-linux_x86/lib --with-mpfr-include=/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/avr32-gnu-toolchain-linux_x86/include --with-gmp=/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/avr32-gnu-toolchain-linux_x86 --with-mpc=/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/avr32-gnu-toolchain-linux_x86 --enable-__cxa_atexit --disable-shared --with-newlib --with-pkgversion=AVR_32_bit_GNU_Toolchain_3.4.2_435 --with-bugurl=http://w
ww
> .atmel.com/avr
>   Thread model: single
>   gcc version 4.4.7 (AVR_32_bit_GNU_Toolchain_3.4.2_435)
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> Acked-by: Hans-Christian Egtvedt <hegtvedt@cisco.com>
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
> 


-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed

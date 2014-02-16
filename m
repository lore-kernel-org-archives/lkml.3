Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaBPLkX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 06:40:23 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:58226 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaBPLkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 06:40:22 -0500
Message-ID: <5300A3B2.4030405@gmail.com>
Date: Sun, 16 Feb 2014 19:40:34 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Weinberger <richard.weinberger@gmail.com>
CC: hskinnemoen@gmail.com, egtvedt@samfundet.no,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: avr32: Makefile: add '-D__linux__' flag for gcc-4.4.7
 using.
References: <52ECEA2A.8070307@gmail.com> <CAFLxGvyEx4NJ-pT4EXT_e6NaFxAwpfpAGL=CPm0o_SM96twaLg@mail.gmail.com> <52ECFAA7.60109@gmail.com>
In-Reply-To: <52ECFAA7.60109@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

Please help check this patch, when you have free time.

Thanks.


On 02/01/2014 09:46 PM, Chen Gang wrote:
> On 02/01/2014 08:56 PM, Richard Weinberger wrote:
>> On Sat, Feb 1, 2014 at 1:35 PM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
>>> For avr32 cross compiler, do not define '__linux__' internally, so it
>>> will cause issue with allmodconfig.
>>
>> Isn't this a toolchain bug?
> 
> Hmm... for me, it is not toolchain's bug, it is a feature issue in gcc
> old version, and in newer version it is OK (in my memory, after gcc-4.7,
> it is OK).
> 
> In our "arch/*", really contents some another architectures which
> already use "-D__linux__" in their "Makefile". :-)
> 
> Thanks.
> 
>>
>>> The related error:
>>>
>>>     CC [M]  fs/coda/psdev.o
>>>   In file included from include/linux/coda.h:64,
>>>                    from fs/coda/psdev.c:45:
>>>   include/uapi/linux/coda.h:221: error: expected specifier-qualifier-list before 'u_quad_t'
>>>
>>> The related toolchain version (which only download, not re-compile):
>>>
>>>   [root@gchen linux-next]# /upstream/toolchain/download/avr32-gnu-toolchain-linux_x86/bin/avr32-gcc -v
>>>   Using built-in specs.
>>>   Target: avr32
>>>   Configured with: /data2/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/src/gcc/configure --target=avr32 --host=i686-pc-linux-gnu --build=x86_64-pc-linux-gnu --prefix=/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/avr32-gnu-toolchain-linux_x86 --enable-languages=c,c++ --disable-nls --disable-libssp --disable-libstdcxx-pch --with-dwarf2 --enable-version-specific-runtime-libs --disable-shared --enable-doc --with-mpfr-lib=/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/avr32-gnu-toolchain-linux_x86/lib --with-mpfr-include=/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/avr32-gnu-toolchain-linux_x86/include --with-gmp=/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/avr32-gnu-toolchain-linux_x86 --with-mpc=/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/avr32-gnu-toolchain-linux_x86 --enable-__cxa_atexit --disable-shared --with-newlib --with-pkgversion=AVR_32_bit_GNU_Toolchain_3.4.2_435 --with-bugurl=http:/
/
> www
>>> .atmel.com/avr
>>>   Thread model: single
>>>   gcc version 4.4.7 (AVR_32_bit_GNU_Toolchain_3.4.2_435)
>>>
>>>
>>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>>> ---
>>>  arch/avr32/Makefile | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/avr32/Makefile b/arch/avr32/Makefile
>>> index 22fb665..dba48a5 100644
>>> --- a/arch/avr32/Makefile
>>> +++ b/arch/avr32/Makefile
>>> @@ -11,7 +11,7 @@ all: uImage vmlinux.elf
>>>
>>>  KBUILD_DEFCONFIG       := atstk1002_defconfig
>>>
>>> -KBUILD_CFLAGS  += -pipe -fno-builtin -mno-pic
>>> +KBUILD_CFLAGS  += -pipe -fno-builtin -mno-pic -D__linux__
>>>  KBUILD_AFLAGS  += -mrelax -mno-pic
>>>  KBUILD_CFLAGS_MODULE += -mno-relax
>>>  LDFLAGS_vmlinux        += --relax
>>> --
>>> 1.7.11.7
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>
>>
> 
> 


-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed

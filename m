Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab3H0FsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 01:48:04 -0400
Received: from ozlabs.org ([203.10.76.45]:52073 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab3H0FsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 01:48:02 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chen Gang <gang.chen@asianux.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        James Hogan <james.hogan@imgtec.com>, Takashi Iwai <tiwai@suse.de>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: Assembly: need add prefix for h8300 architecture.
In-Reply-To: <521B31F4.9090701@asianux.com>
References: <521B312B.2020806@asianux.com> <521B31F4.9090701@asianux.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 27 Aug 2013 14:42:56 +0930
Message-ID: <87txibbtt3.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> writes:
> If this implementation is correct, the implementation still can be
> improved (at least, it is not quite well to hard code the architecture
> related code in "kernel/" and "usr/" sub-directory).
>
> But it seems, I have no right to add or move files, so welcome any
> members help do it.
>
> And welcome any additional suggestions or completions.

Hmm, how about something like:

#ifdef CONFIG_ARCH_ASM_INCBIN_NEEDS_PREFIX
#include <asm/incbin_prefix.h>
        ASM_INCBIN_PREFIX
#endif /* ARCH_ASM_INCBIN_NEEDS_PREFIX */

Then h8300 can define ARCH_ASM_INCBIN_NEEDS_PREFIX in Kconfig and define
ASM_INCBIN_PREFIX in arch/h8300/include/asm/incbin_prefix.h?

Cheers,
Rusty.

> On 08/26/2013 06:42 PM, Chen Gang wrote:
>> Need add related prefix for h8300, or can not pass compiling by the
>> latest linker.
>> 
>> The related error (allmodconfig for h8300):
>> 
>>   /usr/local/bin/h8300-gchen-elf-ld: h8300 architecture of input file `usr/initramfs_data.o' is incompatible with h8300h output
>>   /usr/local/bin/h8300-gchen-elf-ld: h8300 architecture of input file `kernel/modsign_certificate.o' is incompatible with h8300h output
>> 
>> The cross-compiler's information:
>> 
>>   [root@dhcp122 linux-next]# /usr/local/bin/h8300-gchen-elf-ld -v
>>   GNU ld (GNU Binutils) 2.22
>>   [root@dhcp122 linux-next]# /usr/local/bin/h8300-gchen-elf-as -v
>>   GNU assembler version 2.22 (h8300-gchen-elf) using BFD version (GNU Binutils) 2.22
>>   
>>   [root@dhcp122 linux-next]# /usr/local/bin/h8300-gchen-elf-gcc -v
>>   Using built-in specs.
>>   COLLECT_GCC=/usr/local/bin/h8300-gchen-elf-gcc
>>   COLLECT_LTO_WRAPPER=/usr/local/libexec/gcc/h8300-gchen-elf/4.8.0/lto-wrapper
>>   Target: h8300-gchen-elf
>>   Configured with: ../gcc-4.8.0/configure --target=h8300-gchen-elf --without-header --disable-nls --enable-language=c --disable-threads --disable-shared --enable-werror=no
>>   Thread model: single
>>   gcc version 4.8.0 (GCC) 
>> 
>> 
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  kernel/modsign_certificate.S |    7 +++++++
>>  usr/initramfs_data.S         |    7 +++++++
>>  2 files changed, 14 insertions(+), 0 deletions(-)
>> 
>> diff --git a/kernel/modsign_certificate.S b/kernel/modsign_certificate.S
>> index 4a9a86d..d24acac 100644
>> --- a/kernel/modsign_certificate.S
>> +++ b/kernel/modsign_certificate.S
>> @@ -1,5 +1,12 @@
>>  #include <linux/export.h>
>>  
>> +#if defined(CONFIG_CPU_H8300H)
>> +	.h8300h
>> +#endif
>> +#if defined(CONFIG_CPU_H8S)
>> +	.h8300s
>> +#endif
>> +
>>  #define GLOBAL(name)	\
>>  	.globl VMLINUX_SYMBOL(name);	\
>>  	VMLINUX_SYMBOL(name):
>> diff --git a/usr/initramfs_data.S b/usr/initramfs_data.S
>> index c14322d..6a6c106 100644
>> --- a/usr/initramfs_data.S
>> +++ b/usr/initramfs_data.S
>> @@ -24,6 +24,13 @@
>>  #include <linux/stringify.h>
>>  #include <asm-generic/vmlinux.lds.h>
>>  
>> +#if defined(CONFIG_CPU_H8300H)
>> +	.h8300h
>> +#endif
>> +#if defined(CONFIG_CPU_H8S)
>> +	.h8300s
>> +#endif
>> +
>>  .section .init.ramfs,"a"
>>  __irf_start:
>>  .incbin __stringify(INITRAMFS_IMAGE)
>> 
>
>
> -- 
> Chen Gang

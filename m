Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab3FVJ33 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 05:29:29 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:60635 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab3FVJ30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 05:29:26 -0400
Message-ID: <51C56E73.2020802@zankel.net>
Date: Sat, 22 Jun 2013 02:29:23 -0700
From: Chris Zankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Max Filippov <jcmvbkbc@gmail.com>, linux-xtensa@linux-xtensa.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: xtensa: include: asm: define '_PAGE_CHG_MASK' when
 'NOMMU'
References: <51C554F4.8060704@asianux.com> <51C5564D.70106@asianux.com>
In-Reply-To: <51C5564D.70106@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen,

On 06/22/2013 12:46 AM, Chen Gang wrote:
> After define it, with the same .config file, also report another errors
> below, Did I use the incorrect cross-compiler tools ?

It almost seems that you are not using the cross compiler. There are two
ways to specify the cross compiler.
1. As part of the config: make ARCH=xtensa menuconfig and set General
setup ---> (xtensa-linux-gnu-) Cross-compiler tool prefix
2. Provide with make: make ARCH=xtensa CROSS_COMPILE=xtensa-linux-gnu-

Since you are not specifying CROSS_COMPILE, did you configure it in .config?

-Chris

>
> (the attachment is the related .config file)
>
> Thanks.
>
>
> The related environments:
>
> [root@dhcp122 ~]# rpm -qf /usr/bin/xtensa-linux-gnu-gcc
> gcc-xtensa-linux-gnu-4.7.1-0.1.20120606.fc17.x86_64
> [root@dhcp122 ~]# /usr/bin/xtensa-linux-gnu-gcc -v
> Using built-in specs.
> COLLECT_GCC=/usr/bin/xtensa-linux-gnu-gcc
> COLLECT_LTO_WRAPPER=/usr/libexec/gcc/xtensa-linux-gnu/4.7.1/lto-wrapper
> Target: xtensa-linux-gnu
> Configured with: ../gcc-4.7.1-RC-20120606/configure --disable-dependency-tracking --disable-silent-rules --prefix=/usr --exec-prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin --sysconfdir=/etc --datadir=/usr/share --includedir=/usr/include --libexecdir=/usr/libexec --localstatedir=/var --sharedstatedir=/var/lib --mandir=/usr/share/man --infodir=/usr/share/info --build=x86_64-redhat-linux-gnu --host=x86_64-redhat-linux-gnu --target=xtensa-linux-gnu --enable-targets=all --program-prefix=xtensa-linux-gnu- --enable-languages=c --without-headers --enable-sjlj-exceptions --with-system-libunwind --disable-nls --disable-threads --disable-shared --disable-libmudflap --disable-libssp --disable-libgomp --disable-libquadmath --disable-gold --disable-decimal-float --enable-checking= --enable-gnu-unique-object --enable-linker-build-id --disable-plugin --enable-nls --with-system-zlib --with-bugurl=http://bugzilla.redhat.com/bugzilla/ --enable-obsolete
> Thread model: single
> gcc version 4.7.1 20120606 (Red Hat 4.7.1-0.1.20120606) (GCC)
>
> When type the command "make ARCH=xtensa allmodconfig", it always reports:
>   "gcc: error: unrecognized command line option ‘-mlongcalls’"
>
> The related error:
>
>   AS      arch/xtensa/kernel/coprocessor.o
> arch/xtensa/kernel/coprocessor.S: Assembler messages:
> arch/xtensa/kernel/coprocessor.S:98: Error: invalid register number (0) for 'rur0'
> arch/xtensa/kernel/coprocessor.S:98: Error: invalid register number (1) for 'rur1'
> arch/xtensa/kernel/coprocessor.S:98: Error: invalid register number (2) for 'rur2'
> arch/xtensa/kernel/coprocessor.S:98: Error: invalid register number (3) for 'rur3'
> arch/xtensa/kernel/coprocessor.S:98: Error: invalid register number (8) for 'rur8'
> arch/xtensa/kernel/coprocessor.S:98: Error: invalid register number (9) for 'rur9'
> arch/xtensa/kernel/coprocessor.S:98: Error: invalid register number (10) for 'rur10'
> arch/xtensa/kernel/coprocessor.S:98: Error: invalid register number (11) for 'rur11'
> arch/xtensa/kernel/coprocessor.S:98: Error: invalid register number (12) for 'rur12'
> arch/xtensa/kernel/coprocessor.S:98: Error: invalid register number (13) for 'rur13'
> arch/xtensa/kernel/coprocessor.S:98: Error: invalid register number (24) for 'rur24'
> arch/xtensa/kernel/coprocessor.S:98: Error: invalid register number (25) for 'rur25'
> arch/xtensa/kernel/coprocessor.S:98: Error: invalid register number (26) for 'rur26'
> arch/xtensa/kernel/coprocessor.S:98: Error: invalid register number (27) for 'rur27'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wras128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wras128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wras128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wras128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wras128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wras128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wras128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wras128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wras128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wras128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wras128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wras128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wras128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wras128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wras128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wras128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wrbs128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wrbs128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wrbs128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wrbs128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wrbs128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wrbs128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wrbs128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wrbs128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wrbs128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wrbs128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wrbs128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wrbs128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wrbs128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wrbs128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wrbs128i'
> arch/xtensa/kernel/coprocessor.S:98: Error: unknown opcode or format name 'wrbs128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: invalid register number (0) for 'wur0'
> arch/xtensa/kernel/coprocessor.S:107: Error: invalid register number (1) for 'wur1'
> arch/xtensa/kernel/coprocessor.S:107: Error: invalid register number (2) for 'wur2'
> arch/xtensa/kernel/coprocessor.S:107: Error: invalid register number (3) for 'wur3'
> arch/xtensa/kernel/coprocessor.S:107: Error: invalid register number (8) for 'wur8'
> arch/xtensa/kernel/coprocessor.S:107: Error: invalid register number (9) for 'wur9'
> arch/xtensa/kernel/coprocessor.S:107: Error: invalid register number (10) for 'wur10'
> arch/xtensa/kernel/coprocessor.S:107: Error: invalid register number (11) for 'wur11'
> arch/xtensa/kernel/coprocessor.S:107: Error: invalid register number (12) for 'wur12'
> arch/xtensa/kernel/coprocessor.S:107: Error: invalid register number (13) for 'wur13'
> arch/xtensa/kernel/coprocessor.S:107: Error: invalid register number (24) for 'wur24'
> arch/xtensa/kernel/coprocessor.S:107: Error: invalid register number (25) for 'wur25'
> arch/xtensa/kernel/coprocessor.S:107: Error: invalid register number (26) for 'wur26'
> arch/xtensa/kernel/coprocessor.S:107: Error: invalid register number (27) for 'wur27'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wrbl128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wrbl128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wrbl128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wrbl128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wrbl128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wrbl128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wrbl128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wrbl128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wrbl128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wrbl128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wrbl128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wrbl128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wrbl128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wrbl128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wrbl128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wrbl128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wral128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wral128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wral128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wral128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wral128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wral128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wral128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wral128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wral128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wral128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wral128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wral128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wral128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wral128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wral128i'
> arch/xtensa/kernel/coprocessor.S:107: Error: unknown opcode or format name 'wral128i'
> make[1]: *** [arch/xtensa/kernel/coprocessor.o] Error 1
> make: *** [arch/xtensa/kernel] Error 2
>
>
> On 06/22/2013 03:40 PM, Chen Gang wrote:
>> Define '_PAGE_CHG_MASK' when 'NOMMU' to pass compiling.
>>
>> The related make:
>>
>>   make ARCH=xtensa allmodconfig
>>   make ARCH=xtensa menuconfig
>>     set "xtensa-linux-gnu-" for "Cross compilier tool prefix"
>>     select "s6000" for "Processor type and features" -> "Xtensa Processor"
>>   make ARCH=xtensa EXTRA_CFLAGS=-W
>>
>> The related error:
>>
>>   arch/xtensa/include/asm/pgtable.h: In function ‘pte_modify’:
>>   arch/xtensa/include/asm/pgtable.h:289:9: error: ‘_PAGE_CHG_MASK’ undeclared (first use in this function)
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  arch/xtensa/include/asm/pgtable.h |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/xtensa/include/asm/pgtable.h b/arch/xtensa/include/asm/pgtable.h
>> index 7e09f70..a28c49b 100644
>> --- a/arch/xtensa/include/asm/pgtable.h
>> +++ b/arch/xtensa/include/asm/pgtable.h
>> @@ -149,9 +149,10 @@
>>  #define _PAGE_DIRTY		(1<<7)	/* software: page dirty */
>>  #define _PAGE_ACCESSED		(1<<8)	/* software: page accessed (read) */
>>  
>> +#define _PAGE_CHG_MASK	   (PAGE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
>> +
>>  #ifdef CONFIG_MMU
>>  
>> -#define _PAGE_CHG_MASK	   (PAGE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
>>  #define _PAGE_PRESENT	   (_PAGE_HW_VALID | _PAGE_CA_WB | _PAGE_ACCESSED)
>>  
>>  #define PAGE_NONE	   __pgprot(_PAGE_NONE | _PAGE_USER)
>>
>



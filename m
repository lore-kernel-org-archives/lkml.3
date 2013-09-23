Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab3IWGkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 02:40:05 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:61192 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3IWGkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 02:40:03 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Chen Gang <gang.chen@asianux.com>
CC: "jeremy.bennett@embecosm.com" <jeremy.bennett@embecosm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Claudiu Zissulescu" <Claudiu.Zissulescu@synopsys.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        joern Rennecke <joern.rennecke@embecosm.com>
Subject: Re: [Suggestion] arc: compiler: bug: about an arc compiler's bug
 which is not in gcc main source code.
Thread-Topic: [Suggestion] arc: compiler: bug: about an arc compiler's bug
 which is not in gcc main source code.
Thread-Index: AQHOuCLuuJ+I1B5OuE6iMAndydbhgQ==
Date: Mon, 23 Sep 2013 06:39:52 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307514DED9@IN01WEMBXA.internal.synopsys.com>
References: <523FD9E7.3050303@asianux.com> <523FDBD7.4040602@asianux.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.235]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 11:43 AM, Chen Gang wrote:
> Oh, I forgot to supply the related arc cross-compiler's information:
>
> [root@dhcp122 linux-next]# /usr/local/bin/arc-elf32-gcc -v
> Using built-in specs.
> Target: arc-elf32
> Configured with: /mnt/sda11/src/toolchain_arc/unisrc/configure --target=arc-elf32 --with-cpu=arc700 --disable-werror --disable-multilib --with-pkgversion='ARCompact elf32 toolchain (built 20130922)' --with-bugurl=http://solvnet.synopsys.com --enable-fast-install=N/A --enable-languages=c,c++ --prefix=/usr/local --with-headers=/mnt/sda11/src/toolchain_arc/unisrc/newlib/libc/include
> Thread model: single
> gcc version 4.4.7 (ARCompact elf32 toolchain (built 20130922)) 
>
> [root@dhcp122 linux-next]# /usr/local/bin/arc-elf32-as -v
> GNU assembler version 2.19.50.ARC_4.4 (arc-elf32) using BFD version (ARCompact elf32 toolchain (built 20130922)) 2.19.50.ARC_4.4.20081103
>
> [root@dhcp122 linux-next]# /usr/local/bin/arc-elf32-ld -v
> GNU ld (ARCompact elf32 toolchain (built 20130922)) 2.19.50.ARC_4.4.20081103
>
>
> On 09/23/2013 02:04 PM, Chen Gang wrote:
>> Hello arc members:
>>
>> It is arc compiler's bug, but can not report to gnu tool chain (it is
>> not integrated into gnu tool chain), so have to report it here (I find
>> this bug here, and I guess, some arc folks are here, too).
>>
>>
>> In "drivers/power/wm831x_power.c", all wm831x_bat_get_prop() calling
>> functions are inline, so wm831x_bat_get_prop() size is more than 256,
>> but it uses 1 byte to express related offset (".byte .L61-.L65 + 6").
>>
>> If let some of wm831x_bat_get_prop() calling functions noinline, it can
>> pass compiling.
>>
>> The related .s file is in attachment, and the related command and error
>> (for next-20130920 tree) is below:
>>
>>     /usr/local/bin/arc-elf32-gcc -Wp,-MD,drivers/power/.wm831x_power.o.d  -nostdinc -isystem /usr/local/lib/gcc/arc-elf32/4.4.7/include -I/root/linux-next/arch/arc/include -Iarch/arc/include/generated  -Iinclude -I/root/linux-next/arch/arc/include/uapi -Iarch/arc/include/generated/uapi -I/root/linux-next/include/uapi -Iinclude/generated/uapi -include /root/linux-next/include/linux/kconfig.h -include /root/linux-next/arch/arc/include/asm/current.h -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -Os -mA7 -fno-common -pipe -fno-builtin -D__linux__ -fsection-anchors -mlock -mswape -mrtsc -fasynchronous-unwind-tables -mno-sdata -fcall-used-gp -mbig-endian -multcost=16 -fno-reorder-blocks -fno-ipa-cp-clone -Wframe-larger-than=1024 -fno-stack-protector -fomit-frame-pointer -g -femit-struct-debug-baseonly -fno-var-tracking -fno-inline-functions-c
>  alled-onc
> e 
>> -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -Werror=implicit-int -Werror=strict-prototypes -DDEBUG   -DMODULE -mlong-calls  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(wm831x_power)"  -D"KBUILD_MODNAME=KBUILD_STR(wm831x_power)" -c -o drivers/power/.tmp_wm831x_power.o drivers/power/wm831x_power.c
>>   {standard input}: Assembler messages:
>>   {standard input}:934: Error: value of 256 too large for field of 1 bytes at 1987
>>
>>
>> Welcome any suggestions or completions (e.g. which location and members
>> this bug should be reported to).
>>
>> Thanks.

Hi Chen,

Thanks for the problem report. Please note that we have moved on to gcc 4.8 based
tool-chain so I would suggest you switch over to it too (4.4 support is really
phased out).

With current 4.8 tools, I don't see the error you report.

Please use the arc-4.8-dev branch of toolchain repo on github for building the
tools, assuming that is where you got the sources for 4.4 tools too.

Jeremy, Claudiu, Joern maintain the gcc and rest of GNU toolchain ports for ARC so
please add them to any future posting on toolchain issues.

Thx,
-Vineet



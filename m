Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbaFXOo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:44:27 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63405 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667AbaFXOo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:44:26 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53A98EBA.6050900@roeck-us.net>
Date: Tue, 24 Jun 2014 07:44:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, Liqin Chen <liqin.linux@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/score/include/uapi/asm/ptrace.h: Add prefix 'SCORE_'
 for related macros
References: <53A66000.4010208@gmail.com> <53A6669B.1010701@roeck-us.net> <53A66A92.9040106@gmail.com> <53A6EDF6.2030203@roeck-us.net> <53A6EFEC.1020207@roeck-us.net> <53A79905.9020007@gmail.com> <53A97BF6.1060203@gmail.com>
In-Reply-To: <53A97BF6.1060203@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 06:24 AM, Chen Gang wrote:
> On 06/23/2014 11:03 AM, Chen Gang wrote:
>> On 06/22/2014 11:02 PM, Guenter Roeck wrote:
>>> On 06/22/2014 07:53 AM, Guenter Roeck wrote:
>>>> I did that, and managed to build gcc.
>>>>
>>>> However, when trying to compile score defconfig, I get internal
>>>> compiler errors in cc1
>>>> when compiling drivers/tty/tty_mutex.o and block/elevator.o.
>>>>
>>>>    CC      block/elevator.o
>>>> score-elf-gcc: internal compiler error: Segmentation fault (program cc1)
>>>> 0x40c073 execute
>>>>       ../../gcc/gcc/gcc.c:2848
>>>> Please submit a full bug report,
>>>> with preprocessed source if appropriate.
>>>> Please include the complete backtrace with any bug report.
>>>> See <http://gcc.gnu.org/bugs.html> for instructions.
>>>> make[1]: *** [block/elevator.o] Error 4
>>>> make: *** [block/elevator.o] Error 2
>>>>
>>>> Do you see that as well ?
>>>>
>>>> This is with
>>>>
>>>> GNU assembler version 2.24.51 (score-elf) using BFD version (GNU
>>>> Binutils) 2.24.51.20140622
>>>>
>>>> and gcc configured with:
>>>>
>>>> Configured with: ../gcc/configure --prefix=/opt/kernel/score
>>>> --program-prefix=score-elf- \
>>>> --target=score-elf --without-header --disable-nls --enable-languages=c
>>>> --disable-threads \
>>>> --disable-shared --enable-werror=no
>>>> target_configargs=enable_vtable_verify=yes \
>>>> --enable-obsolete --disable-libssp --disable-libquadmath
>>>>
>>>> Tip of gcc source is commit d8686b0aa945a, tip of binutils source is
>>>> commit d17c74c1d41.
>>>> Your assembler fix is included in this version of binutils.
>>>>
>
> Can we repeated this issue, or it is random?  I have try it use my
> current gcc version, it has no issue.
>
> If it can be repeated in the latest version, I shall use version compine
> (and try step by step) to fix it.
>
> If real random issue, if possible, please help repeated and generate
> coredump file, and put it to a place to let me get back for analysing.
>
I got the same error each time. You should be able to reproduce it by
checking out the latest gcc. If that doesn't produce the error, try
checking out sha d8686b0aa945a. I didn't keep that compiler after the tip
of the gcc 4.9 branch worked, so I'd have to rebuild it myself
to reproduce it myself.

Note that compilation of libssp failed with d8686b0aa945a, which is why
I disabled it. I didn't try to build it with 4.9.

Guenter


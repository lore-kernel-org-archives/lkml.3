Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401Ab3HOOpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 10:45:19 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55821 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786Ab3HOOpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 10:45:16 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <520CE978.5010000@roeck-us.net>
Date: Thu, 15 Aug 2013 07:45:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/17] 3.4.58-stable review
References: <20130813063501.728847844@linuxfoundation.org> <520A1D56.2050507@roeck-us.net> <20130813175858.GC7336@kroah.com> <20130813201936.GA18358@roeck-us.net> <CAMuHMdVetwp7r=O_svmnyHBEQzdg-OdRxRB-3TJVQeQ7KULU7g@mail.gmail.com> <20130813223622.GA12790@roeck-us.net> <CAMuHMdVsR3Af+ccWMq6aU99UUAtCXyf8Ss0fbSYw7tR_w2mwkA@mail.gmail.com> <520B5873.6010708@roeck-us.net> <20130815063648.GE25754@kroah.com>
In-Reply-To: <20130815063648.GE25754@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 11:36 PM, Greg Kroah-Hartman wrote:
> On Wed, Aug 14, 2013 at 03:14:11AM -0700, Guenter Roeck wrote:
>> On 08/14/2013 01:26 AM, Geert Uytterhoeven wrote:
>>> On Wed, Aug 14, 2013 at 12:36 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>>>> cris/...:
>>>>>> In file included from include/linux/page-flags.h:8:0,
>>>>>>                    from kernel/bounds.c:9:
>>>>>> include/linux/types.h:25:1: error: unknown type name '__kernel_ino_t'
>>>>>> include/linux/types.h:29:1: error: unknown type name '__kernel_off_t'
>>>>>> include/linux/types.h:30:1: error: unknown type name '__kernel_pid_t'
>>>>>> include/linux/types.h:31:1: error: unknown type name '__kernel_daddr_t'
>>>>>> include/linux/types.h:33:1: error: unknown type name '__kernel_suseconds_t'
>>>>>>
>>>>>> That one might be tricky (or simple if someone knows what is wrong).
>>>>>
>>>>> Fixed in v3.5-rc1:
>>>>>
>>>>> commit 74f077d2a7651409c44bb323471f219a4b0d2aab
>>>>> Author: Jiri Slaby <jslaby@suse.cz>
>>>>> Date:   Mon Apr 2 13:40:17 2012 +0200
>>>>>
>>>>>       cris: posix_types.h, include asm-generic/posix_types.h
>>>>>
>>>> It does fix above error, but then there is another error:
>>>>
>>>>     AS      arch/cris/arch-v10/lib/checksum.o
>>>> In file included from <command-line>:4:0:
>>>> /home/groeck/src/linux-stable/include/linux/kconfig.h:23:0: error: syntax error in macro parameter list
>>>> make[1]: *** [arch/cris/arch-v10/lib/checksum.o] Error 1
>>>> make[1]: *** Waiting for unfinished jobs....
>>>>     AS      arch/cris/arch-v10/lib/checksumcopy.o
>>>> In file included from <command-line>:4:0:
>>>> /home/groeck/src/linux-stable/include/linux/kconfig.h:23:0: error: syntax error in macro parameter list
>>>> make[1]: *** [arch/cris/arch-v10/lib/checksumcopy.o] Error 1
>>>
>>> commit 7b91747d42a1012e3781dd09fa638d113809e3fd
>>> Author: Paul Gortmaker <paul.gortmaker@windriver.com>
>>> Date:   Wed Apr 18 21:58:43 2012 +0200
>>>
>>>       cris: Remove old legacy "-traditional" flag from arch-v10/lib/Makefile
>>>
>>
>> Great, thanks for tracking this down.
>>
>> With both patches applied, we are almost there. Next error:
>>
>> kernel/built-in.o: In function `core_kernel_data':
>> (.text+0x12e38): undefined reference to `_sdata'
>> make: *** [vmlinux] Error 1
>>
>> This has been fixed with commit 473e162e (CRIS: Add _sdata to vmlinux.lds.S).
>>
>> So, in summary, we have
>>
>> 473e162e CRIS: Add _sdata to vmlinux.lds.S
>> 69349c2d cris: Remove old legacy "-traditional" flag from arch-v10/lib/Makefile
>> 7b91747d cris: posix_types.h, include asm-generic/posix_types.h
>>
>> With those three patches applied, cris targets build in 3.4.y.
>
> Wonderful, I've now applied all of these.
>
> Anything else I'm missing for 3.4?
>
Besides the now failing mips buids;

Building arm:allmodconfig ... failed
--------------
Error log:
.config:25:warning: symbol value '' invalid for PHYS_OFFSET
make[2]: *** [silentoldconfig] Error 1
make[1]: *** [silentoldconfig] Error 2
make: *** No rule to make target `include/config/auto.conf', needed by `include/config/kernel.release'.  Stop.

That was "fixed" by a complete arm Kconfig overhaul. I don't think you want
that in 3.4.
--------------

Building frv:defconfig ... failed
--------------
Error log:
[ ... ]
kernel/fork.c: In function 'free_task':
kernel/fork.c:174:2: error: implicit declaration of function 'free_task_struct' [-Werror=implicit-function-declaration]
kernel/fork.c: In function 'dup_task_struct':
kernel/fork.c:266:2: error: implicit declaration of function 'alloc_task_struct_node' [-Werror=implicit-function-declaration]
kernel/fork.c:266:6: warning: assignment makes pointer from integer without a cast [enabled by default]
cc1: some warnings being treated as errors
make[1]: *** [kernel/fork.o] Error 1

I already sent you a sha with a fix for that.

---------------
Building powerpc:chroma_defconfig ... failed
--------------
Error log:
arch/powerpc/mm/numa.c: In function 'do_init_bootmem':
arch/powerpc/mm/numa.c:529:19: error: 'aa.arrays' may be used uninitialized in this function [-Werror=maybe-uninitialized]
arch/powerpc/mm/numa.c:642:22: note: 'aa.arrays' was declared here
cc1: all warnings being treated as errors
make[1]: *** [arch/powerpc/mm/numa.o] Error 1
make: *** [arch/powerpc/mm] Error 2
make: *** Waiting for unfinished jobs....
--------------

That's all. Assuming you revert the mips patch (MIPS: Rewrite pfn_valid to work in modules, too)
and apply the frv patch, we are down to three build failures out of 64 builds. Not too bad.

I now see an occasional qemu runtime crash on the x86 target on 3.4. It doesn't happen
all the time, so it is hard to determine if it is a new problem or an old one.
I'll try to find out. The crash is seen during reboot in native_nmi_stop_other_cpus(),
if that rings a bell with anyone.

Guenter


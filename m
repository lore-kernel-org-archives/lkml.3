Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbaIZRRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:17:37 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:43200 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbaIZRRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:17:35 -0400
MIME-Version: 1.0
In-Reply-To: <54259BD4.8090508@oracle.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
	<1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
	<54259BD4.8090508@oracle.com>
Date: Fri, 26 Sep 2014 21:17:34 +0400
Message-ID: <CAPAsAGzZyFfhK890hUpecrKWowCUW+TiZ32PK2Vb7rFB18+u3A@mail.gmail.com>
Subject: Re: [PATCH v3 00/13] Kernel address sanitizer - runtime memory debugger.
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Michal Marek <mmarek@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kbuild@vger.kernel.org,
        x86@kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-26 21:01 GMT+04:00 Sasha Levin <sasha.levin@oracle.com>:
> On 09/24/2014 08:43 AM, Andrey Ryabinin wrote:
>> Hi.
>>
>> This is a third iteration of kerenel address sanitizer (KASan).
>>
>> KASan is a runtime memory debugger designed to find use-after-free
>> and out-of-bounds bugs.
>>
>> Currently KASAN supported only for x86_64 architecture and requires kernel
>> to be build with SLUB allocator.
>> KASAN uses compile-time instrumentation for checking every memory access, therefore you
>> will need a fresh GCC >= v5.0.0.
>
> Hi Andrey,
>
> I tried this patchset, with the latest gcc, and I'm seeing the following:
>
> arch/x86/kernel/head.o: In function `_GLOBAL__sub_I_00099_0_reserve_ebda_region':
> /home/sasha/linux-next/arch/x86/kernel/head.c:71: undefined reference to `__asan_init_v4'
> init/built-in.o: In function `_GLOBAL__sub_I_00099_0___ksymtab_system_state':
> /home/sasha/linux-next/init/main.c:1034: undefined reference to `__asan_init_v4'
> init/built-in.o: In function `_GLOBAL__sub_I_00099_0_init_uts_ns':
> /home/sasha/linux-next/init/version.c:50: undefined reference to `__asan_init_v4'
> init/built-in.o: In function `_GLOBAL__sub_I_00099_0_root_mountflags':
> /home/sasha/linux-next/init/do_mounts.c:638: undefined reference to `__asan_init_v4'
> init/built-in.o: In function `_GLOBAL__sub_I_00099_0_rd_prompt':
> /home/sasha/linux-next/init/do_mounts_rd.c:361: undefined reference to `__asan_init_v4'
> init/built-in.o:/home/sasha/linux-next/init/do_mounts_md.c:312: more undefined references to `__asan_init_v4' follow
>
>
> What am I missing?
>

__asan_init_v* is a version of compiler's api. Recently it was changed
in gcc - https://gcc.gnu.org/ml/gcc-patches/2014-09/msg01872.html

To fix this, just add:

void __asan_init_v4(void) {}
EXPORT_SYMBOL(__asan_init_v4);

 to the mm/kasan/kasan.c

I'll fix this in next spin.

>
> Thanks,
> Sasha
>
> --



-- 
Best regards,
Andrey Ryabinin

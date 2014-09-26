Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbaIZRH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:07:27 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:35276 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbaIZRHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:07:25 -0400
MIME-Version: 1.0
In-Reply-To: <54259BD4.8090508@oracle.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com> <54259BD4.8090508@oracle.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Fri, 26 Sep 2014 10:07:04 -0700
Message-ID: <CACT4Y+Y0fzbs4DPt3n30R33cYqXEZ8E86tzCfzL6RUE9f+-r=w@mail.gmail.com>
Subject: Re: [PATCH v3 00/13] Kernel address sanitizer - runtime memory debugger.
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
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
        x86@kernel.org, linux-mm@kvack.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 10:01 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
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


Emission of __asan_init_vx needs to be disabled when
-fsanitize=kernel-address. Our kernel does not boot with them at all.
It probably hits some limit for something that can be increased. But I
don't want to investigate what that limit is, as __asan_init is not
needed for kasan at all.

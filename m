Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab3JROVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:21:18 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:47425 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab3JROVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:21:17 -0400
MIME-Version: 1.0
X-Originating-IP: [218.164.102.79]
In-Reply-To: <20131018141202.GA24660@redhat.com>
References: <1382088475.16935.4.camel@phoenix>
	<20131018141202.GA24660@redhat.com>
Date: Fri, 18 Oct 2013 22:21:16 +0800
Message-ID: <CAFRkauDwTBDbjs4+xba0-p_+2mX3tWAN0asUo-aG1ZYjRyaCrg@mail.gmail.com>
Subject: Re: Build error for nommu if CONFIG_DEBUG_ATOMIC_SLEEP is selected
From: Axel Lin <axel.lin@ingics.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/18 Michael S. Tsirkin <mst@redhat.com>:
> On Fri, Oct 18, 2013 at 05:27:55PM +0800, Axel Lin wrote:
>> Hi Michael,
>>
>> I got below build error for nommu if CONFIG_DEBUG_ATOMIC_SLEEP is selected.
>> Also got the same build error if CONFIG_PROVE_LOCKING is selected.
>>
>> Seems this issue is introduced by commit 662bbcb2747c2
>> "mm, sched: Allow uaccess in atomic with pagefault_disable()".
>>
>> arch/arm/kernel/built-in.o: In function `arch_ptrace':
>> arch/arm/kernel/ptrace.c:852: undefined reference to `might_fault'
>> arch/arm/kernel/built-in.o: In function `restore_sigframe':
>> arch/arm/kernel/signal.c:173: undefined reference to `might_fault'
>> arch/arm/kernel/signal.c:174: undefined reference to `might_fault'
>> arch/arm/kernel/signal.c:175: undefined reference to `might_fault'
>> arch/arm/kernel/signal.c:176: undefined reference to `might_fault'
>> arch/arm/kernel/built-in.o:arch/arm/kernel/signal.c:177: more undefined references to `might_fault' follow
>> make: *** [vmlinux] Error 1
>>
>> Regards,
>> Axel
>
> Can you send/upload your full .config please?

I patch the kernel to port it for an arm7tdmi SoC.
But I think you can easily reproduce it by simply
select ARM7TDMI cpu and then enable either
CONFIG_DEBUG_ATOMIC_SLEEP or CONFIG_PROVE_LOCKING.

Note, might_fault is implemented in mm/memory.c which is not built if
!CONFIG_MMU.

Regards,
Axel

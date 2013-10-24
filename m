Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab3JXJKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:10:44 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:47385 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab3JXJKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:10:43 -0400
MIME-Version: 1.0
In-Reply-To: <20131024084559.GD16735@n2100.arm.linux.org.uk>
References: <1382498320-26594-1-git-send-email-tom.leiming@gmail.com>
	<87eh7bfoq9.fsf@rustcorp.com.au>
	<20131024084559.GD16735@n2100.arm.linux.org.uk>
Date: Thu, 24 Oct 2013 17:10:42 +0800
Message-ID: <CACVXFVOXhKE3w0658ztum5E5C-TK=wA4A9Gx7Bn2aRKzEt=OZQ@mail.gmail.com>
Subject: Re: [RFC PATCH] kernel/kallsyms.c: only show legal kernel symbol
From: Ming Lei <tom.leiming@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chen Gang <gang.chen@asianux.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 4:45 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Oct 24, 2013 at 11:51:18AM +1030, Rusty Russell wrote:
>> Ming Lei <tom.leiming@gmail.com> writes:
>> > Address of non-module kernel symbol should always be located
>> > from CONFIG_PAGE_OFFSET on, so only show these legal kernel
>> > symbols in /proc/kallsyms.
>> >
>> > On ARM, some symbols(see below) may drop in relocatable code, so
>> > perf can't parse kernel symbols any more from /proc/kallsyms, this
>> > patch fixes the problem.
>> >
>> >     00000000 t __vectors_start
>> >     00000020 A cpu_v7_suspend_size
>> >     00001000 t __stubs_start
>> >     00001004 t vector_rst
>> >     00001020 t vector_irq
>> >     000010a0 t vector_dabt
>> >     00001120 t vector_pabt
>> >     000011a0 t vector_und
>> >     00001220 t vector_addrexcptn
>> >     00001224 t vector_fiq
>> >     00001224 T vector_fiq_offset
>> >
>> > The issue can be fixed in scripts/kallsyms.c too, but looks this
>> > approach is easier.
>>
>> This fix looks hacky; if these symbols are not available, don't just
>> remove them from /proc/kallsyms, but don't put them in the kernel at
>> all.
>
> How do you "don't put them in the kernel at all" when they're used by
> the kernel internally as offsets?
>
> If you mean, just get rid of them, shall I just add these as magic
> numbers instead based on the values in this email?  Is that really a
> sane solution?
>
> No, we have to keep these symbols IMHO.

If so, looks we have to hide them to userspace, so the patch
should be OK because the approach is correct and no obvious
side-effect.


Thanks,
-- 
Ming Lei

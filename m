Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab3JYBE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 21:04:57 -0400
Received: from ozlabs.org ([203.10.76.45]:37700 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844Ab3JYBE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 21:04:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ming Lei <tom.leiming@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Chen Gang <gang.chen@asianux.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] kernel/kallsyms.c: only show legal kernel symbol
In-Reply-To: <20131024084559.GD16735@n2100.arm.linux.org.uk>
References: <1382498320-26594-1-git-send-email-tom.leiming@gmail.com> <87eh7bfoq9.fsf@rustcorp.com.au> <20131024084559.GD16735@n2100.arm.linux.org.uk>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 25 Oct 2013 09:38:19 +1030
Message-ID: <87mwlyclng.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:
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
>> > 	00000000 t __vectors_start
>> > 	00000020 A cpu_v7_suspend_size
>> > 	00001000 t __stubs_start
>> > 	00001004 t vector_rst
>> > 	00001020 t vector_irq
>> > 	000010a0 t vector_dabt
>> > 	00001120 t vector_pabt
>> > 	000011a0 t vector_und
>> > 	00001220 t vector_addrexcptn
>> > 	00001224 t vector_fiq
>> > 	00001224 T vector_fiq_offset
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

Sorry, I was imprecise.  I was referring to the kernel's kallsyms
tables produced by scripts/kallsyms.c.  This patch left them in the
the kallsyms tables and filtered them out from /proc/kallsyms.

It's weird that cpu_v7_suspend_size appeared above, since kallsyms
should filter out 'A' symbols already.

> If you mean, just get rid of them, shall I just add these as magic
> numbers instead based on the values in this email?  Is that really a
> sane solution?
>
> No, we have to keep these symbols IMHO.

Can you make them absolute symbols?  That should Just Work for kallsyms.

Cheers,
Rusty.

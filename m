Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774AbaKSXEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:04:25 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:58582 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbaKSXEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:04:23 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwykb6aZYgyZXbU1DQ3OL0umpv8gkHYWykBEC2B7UdMbw@mail.gmail.com>
References: <cover.1416352397.git.luto@amacapital.net> <c25e1a64e5b718fa156e141fd9ecbf31011c6059.1416352397.git.luto@amacapital.net>
 <CA+55aFztsw6Vt4CyVs1OsqdKXxQmFrxHdE7z89VMZ_1KwKPcmQ@mail.gmail.com>
 <20141119192928.GL12538@two.firstfloor.org> <CA+55aFwykb6aZYgyZXbU1DQ3OL0umpv8gkHYWykBEC2B7UdMbw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 19 Nov 2014 15:04:00 -0800
Message-ID: <CALCETrXi7vdNAk4RziNDtqX4asPqXxi1VsLzL7pP0zivkjTH4Q@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] sched, x86: Check that we're on the right stack in
 schedule and __might_sleep
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 11:44 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Nov 19, 2014 at 11:29 AM, Andi Kleen <andi@firstfloor.org> wrote:
>>
>> The exception handlers which use the IST stacks don't necessarily
>> set irq count. Maybe they should.
>
> Hmm. I think they should. Since they clearly must not schedule, as
> they use a percpu stack.
>
> Which exceptions use IST?
>
> [ grep grep ]
>
> Looks like stack, doublefault, nmi, debug and mce. And yes, I really
> think they should all raise the irq count if they don't already.
> Rather than add random arch-specific "let's check that we're on the
> right stack" code to the might-sleep stuff, just use the one we have.
>

Does that include nmi?  I'm a bit afraid of touching that code.

It's certainly easy enough to bump irq_count in the paranoid entries.

--Andy

>                     Linus



-- 
Andy Lutomirski
AMA Capital Management, LLC

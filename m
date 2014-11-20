Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbaKTBMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 20:12:19 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:36999 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145AbaKTBMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 20:12:18 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyRYCEoaUh-neg-XQzQHT3dkkp5LhRWkFPMOOH084Ck4A@mail.gmail.com>
References: <cover.1416352397.git.luto@amacapital.net> <c25e1a64e5b718fa156e141fd9ecbf31011c6059.1416352397.git.luto@amacapital.net>
 <CA+55aFztsw6Vt4CyVs1OsqdKXxQmFrxHdE7z89VMZ_1KwKPcmQ@mail.gmail.com>
 <20141119192928.GL12538@two.firstfloor.org> <CA+55aFwykb6aZYgyZXbU1DQ3OL0umpv8gkHYWykBEC2B7UdMbw@mail.gmail.com>
 <CALCETrXi7vdNAk4RziNDtqX4asPqXxi1VsLzL7pP0zivkjTH4Q@mail.gmail.com>
 <CA+55aFx4-WzNQ0e-ZTcCig3b7U7xmt1WB1jzO3TLk9zHD006ng@mail.gmail.com>
 <CALCETrVJJUcPRfkWRouLJCNUVNRH3aWX0X_K8L62yrUu1aR8Vg@mail.gmail.com>
 <CA+55aFy0neTJAAm-8KsmPPU33zevyHmYa+vZjPk-DozSPPW_nQ@mail.gmail.com>
 <CALCETrXzMe2WcpY3yX48WtvdRQDvSg7CZRO1T1TdLynmAcJHXg@mail.gmail.com>
 <CA+55aFxNkD8=1JB0-4EyQTR+Yd0YaofB3+E5J+L3vsfki-RUSQ@mail.gmail.com>
 <CALCETrWBpmS_W3sN3Pf-qRL8jgxoBoQWnQuk3r_TT_eBm9eNqQ@mail.gmail.com> <CA+55aFyRYCEoaUh-neg-XQzQHT3dkkp5LhRWkFPMOOH084Ck4A@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 19 Nov 2014 17:11:56 -0800
Message-ID: <CALCETrUnjii54nfUaCR6AH_pbb+71dJWXC=qvjj7mOJPeVT_qQ@mail.gmail.com>
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

On Wed, Nov 19, 2014 at 5:09 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Nov 19, 2014 at 4:46 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> I'm very hesitant to use irq_enter for this, though.  I think we want
>> just the irq_count part.
>
> Oh, I agree. I mentioned irq_enter/exit() just as the place the
> preempt count increment normally happens. I have nothing against doing
> it manually for these things that really aren't normal interrupts.
>

It may need to be considerably more complicated to keep RCU happy,
though.  In fact, I think that this code is already wrong.

I'll write something and cc Paul to get some feedback.

--Andy

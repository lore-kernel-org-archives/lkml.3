Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbbALUOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:14:55 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:34406 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbbALUOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:14:54 -0500
MIME-Version: 1.0
In-Reply-To: <20150112201145.GH3904@pd.tnic>
References: <1421017655-25561-1-git-send-email-dvlasenk@redhat.com>
 <20150112192314.GF3904@pd.tnic> <CALCETrXzEPKPFKBeKF3UMduNe1ViQTC6vULEySo_0XTJcK7Qkw@mail.gmail.com>
 <20150112193704.GG3904@pd.tnic> <CALCETrUVXGnqqtgw1eZRK5g0B+5vwGuvSV6dwnm5witA-fJWLQ@mail.gmail.com>
 <20150112201145.GH3904@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 12 Jan 2015 12:14:32 -0800
Message-ID: <CALCETrVto_uxTz30M8a4XyLk-UXTQXc3CsYxEKJkhmqH=FdvNA@mail.gmail.com>
Subject: Re: [PATCH] x86: introduce push/pop macros which generate
 CFI_REL_OFFSET and CFI_RESTORE
To: Borislav Petkov <bp@alien8.de>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 12:11 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Jan 12, 2015 at 11:46:53AM -0800, Andy Lutomirski wrote:
>> Dumb example:
>>
>>     pushq_cfi $__KERNEL_DS /* ss */
>>
>> This doesn't save anything that the unwinder would care about.
>
> And? The unwinder or whatever looks at that info simply ignores stuff it
> is not interested in, no?

But CFI_REL_OFFSET $__KERNEL_DS, 0 probably isn't even well-formed and
won't build.

>
>> Better example:
>>
>>     pushq_cfi \child_rip /* rip */
>>     CFI_REL_OFFSET    rip,0
>>
>> Doing this with a macro would need a fancier macro.
>
> I'd ask first whether we really need this at all.
>
>> Then there's crap like:
>>
>>     pushq_cfi %rdi
>>     SCHEDULE_USER
>>     popq_cfi %rdi
>
> I guess we can add a gas regname argument optional and if it is set, use
> it and if not, use the reg itself... Or something like that in the best
> effort type of approach.
>
>> I would need to look a lot more carefully to figure out whether this
>> would need CFI_REL_OFFSET.
>>
>> If we actually had a DWARF unwinder in the kernel, maybe we could have
>> real test cases :-/
>
> I don't think that's ever going to happen.
>
> I'd say we do the CFI annotation on a best effort basis but not
> sacrifice readability in the process. If it can't be annotated, well,
> tough luck.
>

This stuff is at least useful (in theory) for debugging with gdb.  And
I wouldn't mind an optional DWARF unwinder to get higher quality
backtraces.  Obviously any such thing would need to be quite robust.
I think SuSE has one.

> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --



-- 
Andy Lutomirski
AMA Capital Management, LLC

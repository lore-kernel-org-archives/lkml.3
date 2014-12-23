Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359AbaLWStO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 13:49:14 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:47085 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaLWStM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 13:49:12 -0500
MIME-Version: 1.0
In-Reply-To: <20141223091944.GB9112@gmail.com>
References: <20141222200803.D316DA2A@viggo.jf.intel.com> <20141222200804.18A7A803@viggo.jf.intel.com>
 <CALCETrWAgPjLTA-iSabFmqVKiOKGPGgDgSWdjz3wsncs1X+WOg@mail.gmail.com>
 <54987D4F.3000908@sr71.net> <CALCETrXF11MeP8vc4eKqJz+2OOYQzmrK_erVEz=pZS3c=YWibw@mail.gmail.com>
 <20141223091944.GB9112@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 23 Dec 2014 10:48:50 -0800
Message-ID: <CALCETrWuG6kDeGAqMmw7EuSrLBJvU8xWbzMn+A0kjB5eMfEBuA@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86, mpx: explicitly disable 32-bit MPX support on
 64-bit kernels
To: Ingo Molnar <mingo@kernel.org>
Cc: Dave Hansen <dave@sr71.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 1:19 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Andy Lutomirski <luto@amacapital.net> wrote:
>
>> On Mon, Dec 22, 2014 at 12:21 PM, Dave Hansen <dave@sr71.net> wrote:
>> > On 12/22/2014 12:17 PM, Andy Lutomirski wrote:
>> >>> >         /*
>> >>> > +        * 32-bit binaries on 64-bit kernels are currently
>> >>> > +        * unsupported.
>> >>> > +        */
>> >>> > +       if (IS_ENABLED(CONFIG_X86_64) && test_thread_flag(TIF_IA32))
>> >>> > +               return MPX_INVALID_BOUNDS_DIR;
>> >> Should this check mm->ia32_compat instead?
>> >
>> > set_personality_64bit/ia32() seem to make that and TIF_IA32 awfully
>> > equivalent.  Is there a specific reason for wanting it done this way?
>>
>> My general desire to remove various bogus TIF_IA32 references.
>> [...]
>
> So we generally want to use mm->context.ia32_compat instead of
> TIF_IA32, because in the end TIF_IA32 will go away altogether?
>
> Or do you just want to audit all TIF_IA32 places (because most of
> them are wrong), and using mm->context.ia32_compat where it's
> justified and eliminating TIF_IA32 use is a nice way to document
> that ongoing audit without breaking stuff and such?

TBH, I haven't gotten that far.  But of the uses I've looked at, most
seem to want TS_COMPAT instead (is_ia32_task, which is IMO terribly
named), some are so buggier than just using a strange flag, and I
suspect that the rest would make more sense using
mm->context.ia32_compat.

I was planning on sending some patches to incrementally improve the
situation and then seeing where we end up.

>
>> [...]  But this is only temporary, so I don't really care.
>
> New code that touches this area should better use new principles,
> so I have no problem with requiring this, as long as it's well
> explained and logical and desirable to everyone.
>

Given that this patch is a fix for 3.19, the code looks correct, and
the check will go away in 3.20, I see no reason to worry about this
particular patch.

--Andy

> Thanks,
>
>         Ingo



-- 
Andy Lutomirski
AMA Capital Management, LLC

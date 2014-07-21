Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbaGUWOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 18:14:33 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:35809 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbaGUWOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 18:14:32 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1407220006470.20847@nanos>
References: <20140719130602.GA5101@pd.tnic> <53CD6B50.5010404@mit.edu>
 <20140721213534.GB11555@pd.tnic> <CALCETrW91Q=ivYRVFb0WKXgHQO7O+x_HHDy67e90TU6Bte_ecg@mail.gmail.com>
 <20140721215225.GD11555@pd.tnic> <CALCETrX1LbZAiPH4x2Uby_cUUj2wgN92wc+5wvf-B3_9XdObWQ@mail.gmail.com>
 <alpine.DEB.2.10.1407220000080.20847@nanos> <alpine.DEB.2.10.1407220006470.20847@nanos>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 21 Jul 2014 15:14:09 -0700
Message-ID: <CALCETrV93BkGJSj9CWpsVHedax8ypo-a5qEQ6+ZsowvQB0jkJw@mail.gmail.com>
Subject: Re: [PATCH] x86, TSC: Add a software TSC offset
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 3:11 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 22 Jul 2014, Thomas Gleixner wrote:
>> On Mon, 21 Jul 2014, Andy Lutomirski wrote:
>> > On Mon, Jul 21, 2014 at 2:52 PM, Borislav Petkov <bp@alien8.de> wrote:
>> > > On Mon, Jul 21, 2014 at 02:41:50PM -0700, Andy Lutomirski wrote:
>> > >> How will this be compatible with the vdso?
>> > >
>> > > I've never thought about it yet. How compatible would you want it to be
>> > > and what do you expect from it?
>> >
>> > I expect that users of __vdso_clock_gettime (e.g. glibc) will get the
>> > correct time :)  They use vread_tsc, and they can't use
>> > preempt_disable, because they're in userspace.  They also can't
>> > directly access per-cpu variables.
>> >
>> > Turning off vdso tsc support on these machines would be an option.
>>
>> Correct.
>>
>> So if we make the TSC usable that way we need to mark it unusable for
>> the VDSO and force vdso_*gettime* into the kernel. That will be way
>> better than forcing the whole machine onto HPET.
>>
>> And once we are using the real syscall, the whole thing just works ...
>
> So all it needs is to do
>
>     clocksource_tsc.archdata.vclock_mode = VCLOCK_NONE;
>
> if we do the magic per cpu offset trick to make the fcked up TSC
> usable.

Just make sure this happens every time the tsc clocksource is selected
-- it's possible to go back and forth.

>
> Thanks,
>
>         tglx
>



-- 
Andy Lutomirski
AMA Capital Management, LLC

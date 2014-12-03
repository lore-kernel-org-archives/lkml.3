Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaLCXiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:38:55 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:63080 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbaLCXiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:38:51 -0500
MIME-Version: 1.0
In-Reply-To: <20141203153721.30b32472145aa560921bdc1e@linux-foundation.org>
References: <43c88012a4959cd427ab634906e697fbc524e847.1414604015.git.luto@amacapital.net>
 <alpine.DEB.2.11.1410291908290.5308@nanos> <CALCETrWtBCFXzwCAh8fpeFv-EvPxYW20oRmFk1iCYwUvpft=Rw@mail.gmail.com>
 <20141110.211319.1983610686941713044.davem@davemloft.net> <5461EA6B.9020305@nod.at>
 <CALCETrUZhbx-PN8A168khFr6ve_9vdkSiwOcQ-hZbqu4po8hnQ@mail.gmail.com> <20141203153721.30b32472145aa560921bdc1e@linux-foundation.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 3 Dec 2014 15:38:29 -0800
Message-ID: <CALCETrVk0EBL0vk8kjOhjkMAOaxXukCdSptzfHU=g1s7JChXiQ@mail.gmail.com>
Subject: Re: [PATCH v2] all arches, signal: Move restart_block to struct task_struct
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Weinberger <richard@nod.at>, David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 3:37 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 1 Dec 2014 06:55:01 -0800 Andy Lutomirski <luto@amacapital.net> wrote:
>
>> On Tue, Nov 11, 2014 at 2:52 AM, Richard Weinberger <richard@nod.at> wrote:
>> > Am 11.11.2014 um 03:13 schrieb David Miller:
>> >> From: Andy Lutomirski <luto@amacapital.net>
>> >> Date: Mon, 10 Nov 2014 14:03:23 -0800
>> >>
>> >>> On Wed, Oct 29, 2014 at 11:12 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> >>>> On Wed, 29 Oct 2014, Andy Lutomirski wrote:
>> >>>>
>> >>>>> If an attacker can cause a controlled kernel stack overflow,
>> >>>>> overwriting the restart block is a very juicy exploit target.
>> >>>>> Moving the restart block to struct task_struct prevents this
>> >>>>> exploit.
>> >>>>>
>> >>>>> Note that there are other fields in thread_info that are also easy
>> >>>>> targets, at least on some architectures.
>> >>>>>
>> >>>>> It's also a decent simplification, since the restart code is more or
>> >>>>> less identical on all architectures.
>> >>>>
>> >>>> I think that's the most important change. Moving common stuff into
>> >>>> common code. The side effect of slightly reducing the attack surface
>> >>>> is nice, but as Al pointed out not really the big win here.
>> >>>
>> >>> Having gotten exactly zero feedback from any arch maintainer outside
>> >>> of x86, am I supposed to pester people further?
>> >>
>> >> No objections wrt. sparc and if things break I'll help fix it.
>> >
>> > Same for UML.
>> > Acked-by: Richard Weinberger <richard@nod.at>
>>
>> akpm, do you consider this appropriate for either 3.19 or 3.20?  If
>> so, can you add it to the appropriate part of -mm?
>
> Yes, I can grab it.  Probably for .20, as the lag times for exposing
> issues in obscures architectures are lengthy.
>
> One clarification:
>
> : If an attacker can cause a controlled kernel stack overflow,
> : overwriting the restart block is a very juicy exploit target.
>
> This is because the thread_info actually resides in the memory which
> was allocated for the kernel stack, yes?  Whereas the task_struct is
> separately allocated and is harder to find?

Yes, exactly.

>
> Spelling this out in the changelog would be useful for the ignorant and
> the forgetful ;)

Want a new version, or will you fix it up yourself?

Thanks,
Andy

>
> : Moving the restart block to struct task_struct prevents this
> : exploit.
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC

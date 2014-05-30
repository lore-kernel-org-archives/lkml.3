Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934256AbaE3UgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:36:12 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:48303 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbaE3UgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:36:11 -0400
MIME-Version: 1.0
In-Reply-To: <5388E814.1080504@zytor.com>
References: <CALCETrX4-qooSyLw3=zHGcMoWqQ2ozPB_WtKU2AtkMei-XZOUA@mail.gmail.com>
 <537EB60E.40204@1h.com> <CALCETrWgtQCRiHt+am8+DoOMVvTuxy05AB6zzg3iAheGs13L6A@mail.gmail.com>
 <538658EE.8030809@zytor.com> <CALCETrUhZp+edRCx2SEzuJup0HWhV5WSiheCiZWuUjVueTJHfQ@mail.gmail.com>
 <5388E499.6080101@zytor.com> <CALCETrX9s7xJRddB26ZiyjMEGbupbDj2qDHhio=80XSQ+staDA@mail.gmail.com>
 <5388E814.1080504@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 30 May 2014 13:35:49 -0700
Message-ID: <CALCETrVLeUaPRxYu=1-eFVgYDDppAG1DbkQvCKpaUO8NpRWifA@mail.gmail.com>
Subject: Re: Pondering per-process vsyscall disablement
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Marian Marinov <mm@1h.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 1:20 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/30/2014 01:11 PM, Andy Lutomirski wrote:
>> On Fri, May 30, 2014 at 1:05 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 05/30/2014 01:00 PM, Andy Lutomirski wrote:
>>>>
>>>> Do the flags go in the ELF loader or in the executable we're running?
>>>> Or both (and, if both, do we and them or or them)?
>>>>
>>>> I think the interpreter makes a little more sense in general: for the
>>>> most part, use of vsyscalls is a property of the runtime environment,
>>>> not of the program being run.  But maybe this is naive.
>>>>
>>>
>>> They go into each object which becomes part of the running program, i.e.
>>> executable, dynamic libraries, and dynamic linker.
>>
>> Well, sure, but the kernel is not about to start reading ELF headers
>> in dynamic libraries.  So we need to make a decision based on the
>> interpreter and the executable.  The conservative approach is to
>> require both to have the flag set *and* to offer a prctl to twiddle
>> the flags.  Then userspace loaders can do whatever they want, and
>> distros get to rebuild the world :)
>>
>
> Yes, something like that.

I'll hack something up once the merge window closes.  Or maybe sooner
if you commit my vsyscall patches from a few days ago.  Otherwise I'm
just going to confuse my git tree too much :)

--Andy

>
>         -hpa
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Andy Lutomirski
AMA Capital Management, LLC

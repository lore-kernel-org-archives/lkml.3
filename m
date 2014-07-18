Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbaGRBNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 21:13:35 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:43453 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbaGRBNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 21:13:34 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVTm0YWCoj8pLEi9Yu1ECiYLV8CgDhEVehzgw_21eSNAw@mail.gmail.com>
References: <cover.1405095200.git.luto@amacapital.net> <a13ebdd57378120348f40cbe12d9b1705d189434.1405095200.git.luto@amacapital.net>
 <CA+55aFxc1FWkSzRmtRP3XhEJ1Y1p8bc3SiTShhskwjRLJkTazA@mail.gmail.com>
 <CALCETrUqeUJT7xGy0TERVjJUAZUCXJGdgaDWv-f5+vkkArP8ig@mail.gmail.com>
 <20140712183748.GW18735@two.firstfloor.org> <0795204d-575c-40b9-b5b0-75ab14eee330@email.android.com>
 <20140712185202.GX18735@two.firstfloor.org> <CALCETrVTm0YWCoj8pLEi9Yu1ECiYLV8CgDhEVehzgw_21eSNAw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 17 Jul 2014 18:13:12 -0700
Message-ID: <CALCETrWuL1GC1PjYQC3z0LNf=ZVSEYpx0toBvP=twhK-2dcq8Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86_64,signal: Remove 'fs' and 'gs' from sigcontext
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 2:17 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Sat, Jul 12, 2014 at 11:52 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> On Sat, Jul 12, 2014 at 11:40:03AM -0700, H. Peter Anvin wrote:
>>> Because you are doing something weird (like Pin, for example) and take an asynchronous fault?
>>
>> But even for pin that would need executing 16 bit code, or really weird
>> 32bit code. AFAIK for 32bit the only good use case was NX emulation
>> (and old virtualization) which are both completely obsolete.
>
> Nothing particularly weird is needed.  Set a non-default stack segment
> (e.g. any 16-bit ss) and take *any* fault.  This could be something
> asynchronous or even a normal synchronous fault.  Return from the
> signal handler: boom.
>
> We know that people use 16-bit stack segments: it's what prompted the
> whole espfix64 thing.
>
>>
>> I don't think it's worth messing with the signal handlers for 16bit
>> code. If there's any problem with saving/restoring state that emulator
>> can always handle it by itself.
>>
>
> How?
>
> I can think of at least two vaguely feasible ways.  The program could
> ptrace itself, trap sigreturn, and fix ss.  Or it could restore
> registers itself and return using far ret or iret.  Both suck.

You can't even hack around this with ptrace -- ptrace silently fails
to write ss for non-TIF_IA32 tasks.

--Andy

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaJ1SFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:05:05 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:61757 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaJ1SFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:05:03 -0400
MIME-Version: 1.0
In-Reply-To: <20141028174633.GB12195@cloud>
References: <cover.1414516558.git.luto@amacapital.net> <20141028174633.GB12195@cloud>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 28 Oct 2014 11:04:41 -0700
Message-ID: <CALCETrVw5-_BtWBjgZAXC8QUmQfBcktqXHv=szaAFfRWsgMmjQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] x86_64: Tidy up vsyscall emulation and make it optional
To: Josh Triplett <josh@joshtriplett.org>
Cc: X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 10:46 AM,  <josh@joshtriplett.org> wrote:
> On Tue, Oct 28, 2014 at 10:22:25AM -0700, Andy Lutomirski wrote:
>> Now that arch/x86/kernel/vsyscall_64.c contains only vsyscall
>> emulation code, clean it up and make it optional.
>>
>> Patch 1 makes vsyscall=none work be a bit more self-consistent: it
>> actually removes the fake vsyscall page instead of just segfaulting
>> anyone who tries to use it.
>>
>> Patch 2 is pure cosmetic cleanup.
>>
>> Patch 3 is the meat: it lets vsyscall emulation be configured out.
>> The config option to disable it is hidden under CONFIG_EXPERT, since
>> it will break legacy code.
>>
>> Note that, last I checked, current userspace is unlikely to work if
>> the vDSO *and* vsyscalls are off.  Take it up with the glibc
>> maintainers.
>>
>> This applies on top of tip/x86/vdso.
>>
>> Andy Lutomirski (3):
>>   x86_64,vsyscall: Turn vsyscalls all the way off when vsyscall=none
>>   x86_64,vsyscall: Rewrite comment and clean up headers in vsyscall code
>>   x86_64,vsyscall: Make vsyscall emulation configurable
>
> Nice!
>
> For patches 1 and 2:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>
> For patch 3, I responded with a possible minor improvement, but with or
> without that:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>

I think that hunk may be wrong, although oddly I can't trigger the
failure to boot that I'd expect.  I'll send a v2 anyway.

> I assume these should go through tip/x86/vdso as well?

I think so.

>
> Also, any plans to do something similar for vsyscall_gtod.c?
>

I wasn't planning on it, but it could be done.

--Andy

> - Josh Triplett



-- 
Andy Lutomirski
AMA Capital Management, LLC

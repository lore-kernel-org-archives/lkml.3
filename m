Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbaHBVjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 17:39:19 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:60738 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbaHBVjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 17:39:18 -0400
MIME-Version: 1.0
In-Reply-To: <cd1d542c-ceb9-4c91-aaf9-de702824803a@email.android.com>
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com>
 <1406904498-21647-4-git-send-email-dvlasenk@redhat.com> <53DBDDE1.5070805@zytor.com>
 <CAK1hOcML4guky7VutK1xc3YxNjy4K4bX_78p8+7rEhMW0ZuLdg@mail.gmail.com>
 <53DC10FF.9050704@zytor.com> <CALCETrU2ZUKorqUzFZUJ7TRSUL9fS9yBT+SiSH_Zsz6bHcE36A@mail.gmail.com>
 <cd1d542c-ceb9-4c91-aaf9-de702824803a@email.android.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 2 Aug 2014 14:38:56 -0700
Message-ID: <CALCETrW8mvr4LaFWuDoz+L9XCQFrzb0Fa1E9vuMTEv-YunLsFg@mail.gmail.com>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete "struct pt_regs"
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 2, 2014 at 2:23 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> It would be nice to automate running a T-test on it.

I'll see if I can do something like that.  Using the t statistic seems
like overkill here, though -- timing_test_64 runs millions of
iterations, so even if I batch them, I'll end up with n ~ 1000 (or
even larger), at which point plain old Gaussians should be fine.

--Andy

>
> On August 2, 2014 2:14:50 PM PDT, Andy Lutomirski <luto@amacapital.net> wrote:
>>On Fri, Aug 1, 2014 at 3:13 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 08/01/2014 03:11 PM, Denys Vlasenko wrote:
>>>>>
>>>>> Could you please try to see if there is a measurable change in the
>>>>> latency of a trivial syscall?
>>>>
>>>> Will do.
>>>> Something along the lines of "how long does it take to execute two
>>>> gazillions of getppid()?"
>>>>
>>>
>>> Something like that, yes, but you have to run enough data points so
>>you
>>> can determine if the difference is statistically significant or just
>>noise.
>>
>>Denys, if you want to avoid five minutes of programming, you can build
>>this:
>>
>>https://gitorious.org/linux-test-utils/linux-clock-tests/
>>
>>and run timing_test_64 10 getpid
>>
>>It doesn't do real statistics, but it seems to get quite stable
>>results.
>>
>>--Andy
>
> --
> Sent from my mobile phone.  Please pardon brevity and lack of formatting.



-- 
Andy Lutomirski
AMA Capital Management, LLC

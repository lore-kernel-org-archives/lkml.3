Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbaHBVXe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 17:23:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35290 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbaHBVXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 17:23:33 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CALCETrU2ZUKorqUzFZUJ7TRSUL9fS9yBT+SiSH_Zsz6bHcE36A@mail.gmail.com>
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com> <1406904498-21647-4-git-send-email-dvlasenk@redhat.com> <53DBDDE1.5070805@zytor.com> <CAK1hOcML4guky7VutK1xc3YxNjy4K4bX_78p8+7rEhMW0ZuLdg@mail.gmail.com> <53DC10FF.9050704@zytor.com> <CALCETrU2ZUKorqUzFZUJ7TRSUL9fS9yBT+SiSH_Zsz6bHcE36A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete "struct pt_regs"
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 02 Aug 2014 14:23:04 -0700
To: Andy Lutomirski <luto@amacapital.net>
CC: Denys Vlasenko <vda.linux@googlemail.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Message-ID: <cd1d542c-ceb9-4c91-aaf9-de702824803a@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would be nice to automate running a T-test on it.

On August 2, 2014 2:14:50 PM PDT, Andy Lutomirski <luto@amacapital.net> wrote:
>On Fri, Aug 1, 2014 at 3:13 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 08/01/2014 03:11 PM, Denys Vlasenko wrote:
>>>>
>>>> Could you please try to see if there is a measurable change in the
>>>> latency of a trivial syscall?
>>>
>>> Will do.
>>> Something along the lines of "how long does it take to execute two
>>> gazillions of getppid()?"
>>>
>>
>> Something like that, yes, but you have to run enough data points so
>you
>> can determine if the difference is statistically significant or just
>noise.
>
>Denys, if you want to avoid five minutes of programming, you can build
>this:
>
>https://gitorious.org/linux-test-utils/linux-clock-tests/
>
>and run timing_test_64 10 getpid
>
>It doesn't do real statistics, but it seems to get quite stable
>results.
>
>--Andy

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.

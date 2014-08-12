Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaHLUnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 16:43:11 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:38770 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaHLUnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 16:43:09 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrUV+CSJzBzec7fRc6k4yDd+kCxz6Zi8zGNOQvACoKkP9A@mail.gmail.com>
References: <1405657206-12060-1-git-send-email-ast@plumgrid.com>
	<1405657206-12060-11-git-send-email-ast@plumgrid.com>
	<CALCETrUt1yLXTt5pDZJd0s4s+4dhs0LB7tbJYd6p1+EbdNWw7w@mail.gmail.com>
	<CAMEtUuygJoH+PBNksTwRHyRObCZixoTDFzmnHroErZHZLaGNbg@mail.gmail.com>
	<CALCETrUDb6kLH_Qp=YMm=m3P_hmEu3dfDTse=ptCsdpO9EEcAQ@mail.gmail.com>
	<CAMEtUuz2DS8Ks0L15K0Jsj_nFjgvDh0TBwb+5pHzrdU+o6co_g@mail.gmail.com>
	<CALCETrUV+CSJzBzec7fRc6k4yDd+kCxz6Zi8zGNOQvACoKkP9A@mail.gmail.com>
Date: Tue, 12 Aug 2014 13:43:07 -0700
Message-ID: <CAMEtUuyUfgMJkKmWVp-4409TqZouKum_f1NP8T_H+XSHWAfRRg@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 10/16] bpf: add eBPF verifier
From: Alexei Starovoitov <ast@plumgrid.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 1:10 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, Aug 12, 2014 at 1:00 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>> On Tue, Aug 12, 2014 at 12:32 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> On Thu, Jul 24, 2014 at 12:25 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>>>> On Thu, Jul 24, 2014 at 11:25 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>>> On Thu, Jul 17, 2014 at 9:20 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>>>>>> Safety of eBPF programs is statically determined by the verifier, which detects:
>>>>>> - loops
>>>>>> - out of range jumps
>>>>>> - unreachable instructions
>>>>>> - invalid instructions
>>>>>> - uninitialized register access
>>>>>> - uninitialized stack access
>>>>>> - misaligned stack access
>>>>>> - out of range stack access
>>>>>> - invalid calling convention
>>>>>
>>>>> Is there something that documents exactly what conditions an eBPF
>>>>> program must satisfy in order to be considered valid?
>>>>
>>>> I did a writeup in the past on things that verifiers checks and gave it
>>>> to internal folks to review. Guys have said that now they understand very
>>>> well how it works, but in reality it didn't help at all to write valid programs.
>>>> What worked is 'verification trace' = the instruction by instruction dump
>>>> of verifier state while it's analyzing the program.
>>>> I gave few simple examples of it in
>>>> 'Understanding eBPF verifier messages' section:
>>>> https://git.kernel.org/cgit/linux/kernel/git/ast/bpf.git/diff/Documentation/networking/filter.txt?id=b22459133b9f52d2176c8c0f8b5eb036478a40c9
>>>> Every example there is what "program must satisfy to be valid"...
>>>>
>>>> Therefore I'm addressing two things:
>>>> 1. how verifier works and what it checks for.
>>>>   that is described in 'eBPF verifier' section of the doc and
>>>>   in 200 lines of comments inside verifier.c
>>>
>>> That doc is pretty good.  I'll try to read it carefully soon.  Sorry
>>> for the huge delay here -- I've been on vacation.
>>
>> I've been sitting on v4 for few weeks, since it's a merge window.
>> So please hold on a careful review. I'll post v4 later today.
>> Mainly I've split the verifier into several patches to make it
>> easier to read.
>> Thanks!
>
> Will you be at KS / LSS / LinuxCon?

I would love to, but I didn't get an invite for KS.
I'll be at plumbers in October.

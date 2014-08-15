Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaHOTdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:33:05 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:60125 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaHOTdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:33:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAMEtUuzDxzPHsch24U_NjX23r6BvmK9b723HHJeNwQOJeA8r1A@mail.gmail.com>
References: <1407916658-8731-1-git-send-email-ast@plumgrid.com>
 <1407916658-8731-18-git-send-email-ast@plumgrid.com> <CALCETrV7vO6r--G2ns+A6qmDQYSzNXeemT=x41EF+XWmayM95g@mail.gmail.com>
 <CAMEtUuzCyxdOo+yYYZfDPRAu2yeQOw8TbUABwU-HD0+78PnV7A@mail.gmail.com>
 <CALCETrUQN=vt3EUO=jNFC+sDHAiJdNyZWg4rwiEF7WKjPLi8Bg@mail.gmail.com>
 <CAMEtUuyDJeEJjzsZemFLT_y_QJ+vnJjze=KOxV+7g58Tsf4cTw@mail.gmail.com>
 <CALCETrW4Yscrte9=_ks_1BhSE9FTe-KZTv_a=g5wrwKhKkiuow@mail.gmail.com> <CAMEtUuzDxzPHsch24U_NjX23r6BvmK9b723HHJeNwQOJeA8r1A@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 15 Aug 2014 12:32:41 -0700
Message-ID: <CALCETrUXeBSv6KbsPC+kHTAbAB2B8T3rk5N-OOZvCPU8fOr5Ew@mail.gmail.com>
Subject: Re: [PATCH RFC v4 net-next 17/26] tracing: allow eBPF programs to be
 attached to events
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
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

On Fri, Aug 15, 2014 at 12:29 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> On Fri, Aug 15, 2014 at 12:20 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>>
>>>> I don't think that fixing this should be a prerequisite for merging,
>>>> since the risk is so small.  Nonetheless, it would be nice.  (This
>>>> family of attacks has lead to several root vulnerabilities in the
>>>> past.)
>>>
>>> Ok. I think keeping a track of pid between open and write is kinda
>>> ugly.
>>
>> Agreed.
>>
>> TBH, I would just add a comment to the open implementation saying
>> that, if unprivileged or less privileged open is allowed, then this
>> needs to be fixed.
>
> ok. will do.
>
>>> Should we add some new CAP flag and check it for all file
>>> ops? Another option is to conditionally make open() of tracing
>>> files as cloexec...
>>
>> That won't help.  The same attack can be done with SCM_RIGHTS, and
>> cloexec can be cleared.
>
> ouch, can we then make ebpf FDs and may be debugfs FDs
> not passable at all? Otherwise it feels that generality and
> flexibility of FDs is becoming a burden.

I'm not sure there's much of a general problem.  The issue is when
there's an fd for which write(2) (or other
assumed-to-not-check-permissions calls like read, pread, pwrite, etc)
depend on context.  This is historically an issue for netlink and
various /proc files.

--Andy

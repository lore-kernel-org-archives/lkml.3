Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaHOT3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:29:41 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:63876 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaHOT3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:29:39 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrW4Yscrte9=_ks_1BhSE9FTe-KZTv_a=g5wrwKhKkiuow@mail.gmail.com>
References: <1407916658-8731-1-git-send-email-ast@plumgrid.com>
	<1407916658-8731-18-git-send-email-ast@plumgrid.com>
	<CALCETrV7vO6r--G2ns+A6qmDQYSzNXeemT=x41EF+XWmayM95g@mail.gmail.com>
	<CAMEtUuzCyxdOo+yYYZfDPRAu2yeQOw8TbUABwU-HD0+78PnV7A@mail.gmail.com>
	<CALCETrUQN=vt3EUO=jNFC+sDHAiJdNyZWg4rwiEF7WKjPLi8Bg@mail.gmail.com>
	<CAMEtUuyDJeEJjzsZemFLT_y_QJ+vnJjze=KOxV+7g58Tsf4cTw@mail.gmail.com>
	<CALCETrW4Yscrte9=_ks_1BhSE9FTe-KZTv_a=g5wrwKhKkiuow@mail.gmail.com>
Date: Fri, 15 Aug 2014 12:29:38 -0700
Message-ID: <CAMEtUuzDxzPHsch24U_NjX23r6BvmK9b723HHJeNwQOJeA8r1A@mail.gmail.com>
Subject: Re: [PATCH RFC v4 net-next 17/26] tracing: allow eBPF programs to be
 attached to events
From: Alexei Starovoitov <ast@plumgrid.com>
To: Andy Lutomirski <luto@amacapital.net>
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

On Fri, Aug 15, 2014 at 12:20 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>
>>> I don't think that fixing this should be a prerequisite for merging,
>>> since the risk is so small.  Nonetheless, it would be nice.  (This
>>> family of attacks has lead to several root vulnerabilities in the
>>> past.)
>>
>> Ok. I think keeping a track of pid between open and write is kinda
>> ugly.
>
> Agreed.
>
> TBH, I would just add a comment to the open implementation saying
> that, if unprivileged or less privileged open is allowed, then this
> needs to be fixed.

ok. will do.

>> Should we add some new CAP flag and check it for all file
>> ops? Another option is to conditionally make open() of tracing
>> files as cloexec...
>
> That won't help.  The same attack can be done with SCM_RIGHTS, and
> cloexec can be cleared.

ouch, can we then make ebpf FDs and may be debugfs FDs
not passable at all? Otherwise it feels that generality and
flexibility of FDs is becoming a burden.

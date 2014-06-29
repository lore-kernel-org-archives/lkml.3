Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaF2B7N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 21:59:13 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:34978 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaF2B7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 21:59:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAMEtUuzq4ib6MFAsp_ZpBisRa=XFUgKkX7OwwrEoOfw7O1YXCQ@mail.gmail.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
 <1403913966-4927-9-git-send-email-ast@plumgrid.com> <CALCETrV+uTamX2BShHsHnwTr4R7+MSQXX8bXe=2Xo1hbiSAipQ@mail.gmail.com>
 <CAMEtUuzq4ib6MFAsp_ZpBisRa=XFUgKkX7OwwrEoOfw7O1YXCQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 28 Jun 2014 18:58:50 -0700
Message-ID: <CALCETrV-uUL=NJ5_XP90cMmxvVJ0PHxCb7f4L=TqGX9tB5Vi2Q@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 08/14] bpf: add eBPF verifier
To: Alexei Starovoitov <ast@plumgrid.com>
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

On Sat, Jun 28, 2014 at 1:25 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> On Sat, Jun 28, 2014 at 9:01 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Fri, Jun 27, 2014 at 5:06 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>>> Safety of eBPF programs is statically determined by the verifier, which detects:
>>
>> This is a very high-level review.  I haven't tried to read all the
>> code yet, and this is mostly questions rather than real comments.
>

> These were great questions! I hope I answered them. If not, please
> continue asking.

I have plenty more questions, but here's one right now: does anything
prevent programs from using pointers in comparisons, returning
pointers, or otherwise figuring out the value of a pointer?  If so, I
think it would be worthwhile to prevent that so that eBPF programs
can't learn kernel addresses.

--Andy

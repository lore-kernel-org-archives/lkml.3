Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbaHZBn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 21:43:59 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:50027 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416AbaHZBn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 21:43:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140825.180718.137768107010295086.davem@davemloft.net>
References: <1409014858-1410-1-git-send-email-ast@plumgrid.com>
	<1409014858-1410-5-git-send-email-ast@plumgrid.com>
	<20140825.180718.137768107010295086.davem@davemloft.net>
Date: Mon, 25 Aug 2014 18:43:55 -0700
Message-ID: <CAMEtUuy1DXFMABAg2Uup5HtqmiJHw0WR=or-z9CfpVMscrVcVg@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 4/6] bpf: enable bpf syscall on x64 and i386
From: Alexei Starovoitov <ast@plumgrid.com>
To: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 6:07 PM, David Miller <davem@davemloft.net> wrote:
> From: Alexei Starovoitov <ast@plumgrid.com>
> Date: Mon, 25 Aug 2014 18:00:56 -0700
>
>> -
>> +asmlinkage long sys_bpf(int cmd, unsigned long arg2, unsigned long arg3,
>> +                     unsigned long arg4, unsigned long arg5);
>
> Please do not add interfaces with opaque types as arguments.
>
> It is impossible for the compiler to type check the args at
> compile time when userspace tries to use this stuff.

I share this concern. I went with single BPF syscall, because
alternative is 6 syscalls for every command and more
syscalls in the future when we'd need to add another command.
I think type casting is much lesser evil.
We already have similar muxing syscalls.
It feels to me that single mux/demux syscall is easier to support,
document, add new commands. Type casting, yeah, not pretty.
Most users will be using wrappers similar to those I've defined in libbpf.h

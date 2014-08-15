Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaHOF4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 01:56:12 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:49187 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaHOF4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 01:56:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAE40pddG1e3Q8OZ8t5QQimGhHzS5FbqK3YuvKnFywEEoSUbGzQ@mail.gmail.com>
References: <1407916658-8731-1-git-send-email-ast@plumgrid.com>
	<1407916658-8731-24-git-send-email-ast@plumgrid.com>
	<CAE40pddG1e3Q8OZ8t5QQimGhHzS5FbqK3YuvKnFywEEoSUbGzQ@mail.gmail.com>
Date: Thu, 14 Aug 2014 22:56:07 -0700
Message-ID: <CAMEtUux1hK-fU6FHTU3==TW2c50Q-UHEpb=t_d3dG1A7pJM2bA@mail.gmail.com>
Subject: Re: [PATCH RFC v4 net-next 23/26] samples: bpf: elf file loader
From: Alexei Starovoitov <ast@plumgrid.com>
To: Brendan Gregg <brendan.d.gregg@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 12:29 PM, Brendan Gregg
<brendan.d.gregg@gmail.com> wrote:
> On Wed, Aug 13, 2014 at 12:57 AM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> [...]
>> +static int load_and_attach(const char *event, struct bpf_insn *prog, int size)
>> +{
>> +       int fd, event_fd, err;
>> +       char fmt[32];
>> +       char path[256] = DEBUGFS;
>> +
>> +       fd = bpf_prog_load(BPF_PROG_TYPE_TRACING_FILTER, prog, size, license);
>> +
>> +       if (fd < 0) {
>> +               printf("err %d errno %d\n", fd, errno);
>> +               return fd;
>> +       }
>
> Minor suggestion: since this is sample code, I'd always print the bpf
> log after this this printf() error message:
>
> printf("%s", bpf_log_buf);
>
> Which has helped me debug my eBPF programs, as will be the case for
> anyone hacking on the examples.

Good point. Will do in V5.

> Or have a function for logdie(), if
> the log buffer may be populated with useful messages from other error
> paths as well.

This log buffer is an optional buffer that eBPF verifier is using to
store its messages. Mainly for humans to understand why verifier
rejected the program. It's also used by verifier testsuite to check
that reject reason actually matches the test intent.

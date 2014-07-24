Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538AbaGXAGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 20:06:19 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:50893 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758390AbaGXAGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 20:06:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJyw19h0+AwZEWSJt7hGnkRHAsf8fYim=XLzA-LH=svjw@mail.gmail.com>
References: <1405657206-12060-1-git-send-email-ast@plumgrid.com>
	<1405657206-12060-14-git-send-email-ast@plumgrid.com>
	<CAGXu5jJyw19h0+AwZEWSJt7hGnkRHAsf8fYim=XLzA-LH=svjw@mail.gmail.com>
Date: Wed, 23 Jul 2014 17:06:15 -0700
Message-ID: <CAMEtUuy__c2Av1AtWNa5ksH5if3FmhYZ2AnzTYcaAVXrpc4J1A@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 13/16] tracing: allow eBPF programs to be
 attached to events
From: Alexei Starovoitov <ast@plumgrid.com>
To: Kees Cook <keescook@chromium.org>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 4:46 PM, Kees Cook <keescook@chromium.org> wrote:
>>
>> eBPF programs can call in-kernel helper functions to:
>> - lookup/update/delete elements in maps
>> - memcmp
>> - trace_printk
>> - load_pointer
>> - dump_stack
>
> Ah, this must be the pointer leaking you mentioned. :)
>
>
> Can the existing tracing mechanisms already expose kernel addresses? I
> suspect "yes". So I guess existing limitations on tracing exposure
> should already cover access control here? (I'm trying to figure out if
> a separate CONFIG is needed -- I don't think so: nothing "new" is
> exposed via eBPF, is that right?)

correct. through debugfs/tracing the whole kernel is already exposed.
Idea of eBPF for tracing is to give kernel developers and performance
engineers a tool to analyze what kernel is doing by writing programs
in C and attaching them to kprobe/tracepoint events, so it's definitely
for root only.

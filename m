Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbaGAUGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 16:06:35 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36595 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbaGAUGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:06:33 -0400
MIME-Version: 1.0
In-Reply-To: <53B271C0.5090008@redhat.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
	<1403913966-4927-12-git-send-email-ast@plumgrid.com>
	<53B271C0.5090008@redhat.com>
Date: Tue, 1 Jul 2014 13:06:31 -0700
Message-ID: <CAMEtUuwhU6WerFL3gV-B7h0V4gepe=G2LChORHTwS-fYN-eNug@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 11/14] tracing: allow eBPF programs to be
 attached to events
From: Alexei Starovoitov <ast@plumgrid.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
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

On Tue, Jul 1, 2014 at 1:30 AM, Daniel Borkmann <dborkman@redhat.com> wrote:
> On 06/28/2014 02:06 AM, Alexei Starovoitov wrote:
>>
>> User interface:
>> cat bpf_123 > /sys/kernel/debug/tracing/__event__/filter
>>
>> where 123 is an id of the eBPF program priorly loaded.
>> __event__ is static tracepoint event.
>> (kprobe events will be supported in the future patches)
>>
>> eBPF programs can call in-kernel helper functions to:
>> - lookup/update/delete elements in maps
>> - memcmp
>> - trace_printk
>> - load_pointer
>> - dump_stack
>
>
> Are there plans to let eBPF replace the generic event
> filtering framework in tracing?

yes. the other patch that replaces predicate tree walking with
eBPF programs is pending on eBPF split out of networking.

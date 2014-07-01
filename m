Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbaGAIbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:31:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237AbaGAIbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:31:49 -0400
Message-ID: <53B271C0.5090008@redhat.com>
Date: Tue, 01 Jul 2014 10:30:56 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
CC: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 11/14] tracing: allow eBPF programs to be
 attached to events
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com> <1403913966-4927-12-git-send-email-ast@plumgrid.com>
In-Reply-To: <1403913966-4927-12-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2014 02:06 AM, Alexei Starovoitov wrote:
> User interface:
> cat bpf_123 > /sys/kernel/debug/tracing/__event__/filter
>
> where 123 is an id of the eBPF program priorly loaded.
> __event__ is static tracepoint event.
> (kprobe events will be supported in the future patches)
>
> eBPF programs can call in-kernel helper functions to:
> - lookup/update/delete elements in maps
> - memcmp
> - trace_printk
> - load_pointer
> - dump_stack

Are there plans to let eBPF replace the generic event
filtering framework in tracing?

> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
> ---
>   include/linux/ftrace_event.h       |    5 +
>   include/trace/bpf_trace.h          |   29 +++++
>   include/trace/ftrace.h             |   10 ++
>   include/uapi/linux/bpf.h           |    5 +
>   kernel/trace/Kconfig               |    1 +
>   kernel/trace/Makefile              |    1 +
>   kernel/trace/bpf_trace.c           |  217 ++++++++++++++++++++++++++++++++++++
>   kernel/trace/trace.h               |    3 +
>   kernel/trace/trace_events.c        |    7 ++
>   kernel/trace/trace_events_filter.c |   72 +++++++++++-
>   10 files changed, 349 insertions(+), 1 deletion(-)
>   create mode 100644 include/trace/bpf_trace.h
>   create mode 100644 kernel/trace/bpf_trace.c

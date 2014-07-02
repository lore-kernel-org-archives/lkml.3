Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbaGBFfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 01:35:23 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:39914 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbaGBFfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 01:35:21 -0400
MIME-Version: 1.0
In-Reply-To: <8738ek5qyh.fsf@sejong.aot.lge.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
	<1403913966-4927-2-git-send-email-ast@plumgrid.com>
	<8738ek5qyh.fsf@sejong.aot.lge.com>
Date: Tue, 1 Jul 2014 22:35:20 -0700
Message-ID: <CAMEtUuxs55tUtXCq5AuJcRhZYPbSX4bLTEc66e94M6WOQH5pWA@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 01/14] net: filter: split filter.c into two files
From: Alexei Starovoitov <ast@plumgrid.com>
To: Namhyung Kim <namhyung@gmail.com>
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
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2014 at 9:23 PM, Namhyung Kim <namhyung@gmail.com> wrote:
> Hi Alexei,
>
> On Fri, 27 Jun 2014 17:05:53 -0700, Alexei Starovoitov wrote:
>> BPF is used in several kernel components. This split creates logical boundary
>> between generic eBPF core and the rest
>>
>> kernel/bpf/core.c: eBPF interpreter
>>
>> net/core/filter.c: classic->eBPF converter, classic verifiers, socket filters
>>
>> This patch only moves functions.
>>
>> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
>> ---
>>  kernel/Makefile     |    1 +
>>  kernel/bpf/Makefile |    1 +
>>  kernel/bpf/core.c   |  545 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  net/core/filter.c   |  520 ------------------------------------------------
>>  4 files changed, 547 insertions(+), 520 deletions(-)
>>  create mode 100644 kernel/bpf/Makefile
>>  create mode 100644 kernel/bpf/core.c
>>
>> diff --git a/kernel/Makefile b/kernel/Makefile
>> index f2a8b6246ce9..e7360b7c2c0e 100644
>> --- a/kernel/Makefile
>> +++ b/kernel/Makefile
>> @@ -87,6 +87,7 @@ obj-$(CONFIG_RING_BUFFER) += trace/
>>  obj-$(CONFIG_TRACEPOINTS) += trace/
>>  obj-$(CONFIG_IRQ_WORK) += irq_work.o
>>  obj-$(CONFIG_CPU_PM) += cpu_pm.o
>> +obj-$(CONFIG_NET) += bpf/
>
> But this still requires CONFIG_NET to use bpf.  Why not adding
> CONFIG_BPF and making CONFIG_NET selects it?

This is the first patch that does 'split only'. Later patch replaces this line
with CONFIG_BPF.

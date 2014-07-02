Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaGBEXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 00:23:38 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:50212 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaGBEXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 00:23:36 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
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
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 01/14] net: filter: split filter.c into two files
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
	<1403913966-4927-2-git-send-email-ast@plumgrid.com>
Date: Wed, 02 Jul 2014 13:23:34 +0900
In-Reply-To: <1403913966-4927-2-git-send-email-ast@plumgrid.com> (Alexei
	Starovoitov's message of "Fri, 27 Jun 2014 17:05:53 -0700")
Message-ID: <8738ek5qyh.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexei,

On Fri, 27 Jun 2014 17:05:53 -0700, Alexei Starovoitov wrote:
> BPF is used in several kernel components. This split creates logical boundary
> between generic eBPF core and the rest
>
> kernel/bpf/core.c: eBPF interpreter
>
> net/core/filter.c: classic->eBPF converter, classic verifiers, socket filters
>
> This patch only moves functions.
>
> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
> ---
>  kernel/Makefile     |    1 +
>  kernel/bpf/Makefile |    1 +
>  kernel/bpf/core.c   |  545 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  net/core/filter.c   |  520 ------------------------------------------------
>  4 files changed, 547 insertions(+), 520 deletions(-)
>  create mode 100644 kernel/bpf/Makefile
>  create mode 100644 kernel/bpf/core.c
>
> diff --git a/kernel/Makefile b/kernel/Makefile
> index f2a8b6246ce9..e7360b7c2c0e 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -87,6 +87,7 @@ obj-$(CONFIG_RING_BUFFER) += trace/
>  obj-$(CONFIG_TRACEPOINTS) += trace/
>  obj-$(CONFIG_IRQ_WORK) += irq_work.o
>  obj-$(CONFIG_CPU_PM) += cpu_pm.o
> +obj-$(CONFIG_NET) += bpf/

But this still requires CONFIG_NET to use bpf.  Why not adding
CONFIG_BPF and making CONFIG_NET selects it?

Thanks,
Namhyung

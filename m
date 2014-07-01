Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbaGAIFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:05:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755048AbaGAIFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:05:53 -0400
Message-ID: <53B26BB0.90209@redhat.com>
Date: Tue, 01 Jul 2014 10:05:04 +0200
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
Subject: Re: [PATCH RFC net-next 08/14] bpf: add eBPF verifier
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com> <1403913966-4927-9-git-send-email-ast@plumgrid.com>
In-Reply-To: <1403913966-4927-9-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2014 02:06 AM, Alexei Starovoitov wrote:
> Safety of eBPF programs is statically determined by the verifier, which detects:
> - loops
> - out of range jumps
> - unreachable instructions
> - invalid instructions
> - uninitialized register access
> - uninitialized stack access
> - misaligned stack access
> - out of range stack access
> - invalid calling convention
...
> More details in Documentation/networking/filter.txt
>
> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
> ---
...
>   kernel/bpf/verifier.c               | 1431 +++++++++++++++++++++++++++++++++++

Looking at classic BPF verifier which checks safety of BPF
user space programs, it's roughly 200 loc. :-/

> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> new file mode 100644
...
> +#define _(OP) ({ int ret = OP; if (ret < 0) return ret; })
...
> +	_(get_map_info(env, map_id, &map));
...
> +	_(size = bpf_size_to_bytes(bpf_size));

Nit: such macros should be removed, please.

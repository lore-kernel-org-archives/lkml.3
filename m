Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbaF1ATr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 20:19:47 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:62432 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbaF1ATq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 20:19:46 -0400
MIME-Version: 1.0
In-Reply-To: <1403913966-4927-8-git-send-email-ast@plumgrid.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com> <1403913966-4927-8-git-send-email-ast@plumgrid.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 27 Jun 2014 17:19:24 -0700
Message-ID: <CALCETrXDR1LVmbigTicBiddgvcucM1dGk1R7rxdJyBCvGEBQMw@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 07/14] bpf: expand BPF syscall with program load/unload
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

On Fri, Jun 27, 2014 at 5:05 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> eBPF programs are safe run-to-completion functions with load/unload
> methods from userspace similar to kernel modules.
>
> User space API:
>
> - load eBPF program
>   prog_id = bpf_prog_load(int prog_id, bpf_prog_type, struct nlattr *prog, int len)
>
>   where 'prog' is a sequence of sections (currently TEXT and LICENSE)
>   TEXT - array of eBPF instructions
>   LICENSE - GPL compatible


> +
> +       err = -EINVAL;
> +       /* look for mandatory license string */
> +       if (!tb[BPF_PROG_LICENSE])
> +               goto free_attr;
> +
> +       /* eBPF programs must be GPL compatible */
> +       if (!license_is_gpl_compatible(nla_data(tb[BPF_PROG_LICENSE])))
> +               goto free_attr;

Seriously?  My mind boggles.

--Andy

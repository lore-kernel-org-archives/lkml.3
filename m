Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaHNT3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 15:29:12 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:34189 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbaHNT3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 15:29:10 -0400
MIME-Version: 1.0
In-Reply-To: <1407916658-8731-24-git-send-email-ast@plumgrid.com>
References: <1407916658-8731-1-git-send-email-ast@plumgrid.com>
	<1407916658-8731-24-git-send-email-ast@plumgrid.com>
Date: Thu, 14 Aug 2014 12:29:09 -0700
Message-ID: <CAE40pddG1e3Q8OZ8t5QQimGhHzS5FbqK3YuvKnFywEEoSUbGzQ@mail.gmail.com>
Subject: Re: [PATCH RFC v4 net-next 23/26] samples: bpf: elf file loader
From: Brendan Gregg <brendan.d.gregg@gmail.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 12:57 AM, Alexei Starovoitov <ast@plumgrid.com> wrote:
[...]
> +static int load_and_attach(const char *event, struct bpf_insn *prog, int size)
> +{
> +       int fd, event_fd, err;
> +       char fmt[32];
> +       char path[256] = DEBUGFS;
> +
> +       fd = bpf_prog_load(BPF_PROG_TYPE_TRACING_FILTER, prog, size, license);
> +
> +       if (fd < 0) {
> +               printf("err %d errno %d\n", fd, errno);
> +               return fd;
> +       }

Minor suggestion: since this is sample code, I'd always print the bpf
log after this this printf() error message:

printf("%s", bpf_log_buf);

Which has helped me debug my eBPF programs, as will be the case for
anyone hacking on the examples. Or have a function for logdie(), if
the log buffer may be populated with useful messages from other error
paths as well.

Brendan

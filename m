Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbaF1AVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 20:21:30 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:56547 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbaF1AV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 20:21:29 -0400
MIME-Version: 1.0
In-Reply-To: <1403913966-4927-14-git-send-email-ast@plumgrid.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com> <1403913966-4927-14-git-send-email-ast@plumgrid.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 27 Jun 2014 17:21:07 -0700
Message-ID: <CALCETrWGUui53hpRYtA9zmLKLf-r-nC8urq_JgJoRnzRb1d_1w@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 13/14] samples: bpf: example of stateful
 socket filtering
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

On Fri, Jun 27, 2014 at 5:06 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> this socket filter example does:
>
> - creates a hashtable in kernel with key 4 bytes and value 8 bytes
>
> - populates map[6] = 0; map[17] = 0;  // 6 - tcp_proto, 17 - udp_proto
>
> - loads eBPF program:
>   r0 = skb[14 + 9]; // load one byte of ip->proto
>   *(u32*)(fp - 4) = r0;
>   value = bpf_map_lookup_elem(map_id, fp - 4);
>   if (value)
>        (*(u64*)value) += 1;

In the code below, this is XADD.  Is there anything that validates
that shared things like this can only be poked at by atomic
operations?

--Andy

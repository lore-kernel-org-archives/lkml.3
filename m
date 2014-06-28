Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbaF1ARG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 20:17:06 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:63017 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbaF1ARD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 20:17:03 -0400
MIME-Version: 1.0
In-Reply-To: <1403913966-4927-4-git-send-email-ast@plumgrid.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com> <1403913966-4927-4-git-send-email-ast@plumgrid.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 27 Jun 2014 17:16:41 -0700
Message-ID: <CALCETrV3WLBmHewCZgfhCkjODWfq_byRg6sF7HpqZ6n9BVMBVQ@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 03/14] bpf: introduce syscall(BPF, ...) and
 BPF maps
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
> BPF syscall is a demux for different BPF releated commands.
>
> 'maps' is a generic storage of different types for sharing data between kernel
> and userspace.
>
> The maps can be created/deleted from user space via BPF syscall:
> - create a map with given id, type and attributes
>   map_id = bpf_map_create(int map_id, map_type, struct nlattr *attr, int len)
>   returns positive map id or negative error
>
> - delete map with given map id
>   err = bpf_map_delete(int map_id)
>   returns zero or negative error

What's the scope of "id"?  How is it secured?

This question is brought to you by keyctl, which is terminally fucked.
At some point I'll generate some proof of concept exploits for severe
bugs caused by misdesign of a namespace.

--Andy

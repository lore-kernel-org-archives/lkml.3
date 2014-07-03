Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaGCAB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 20:01:27 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:59745 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaGCABZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 20:01:25 -0400
MIME-Version: 1.0
In-Reply-To: <CA+ZOOTM9KkOYJ5Nf25_x1fT+f76xMsdJRkqjYaABiNK9y3FNXA@mail.gmail.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
	<1403913966-4927-9-git-send-email-ast@plumgrid.com>
	<CA+ZOOTODDPN=6SECq1uPPD7AGP1zgBJ+bfYaX9o3YhnaCTiHYQ@mail.gmail.com>
	<CAMEtUuxfrAUDDQVGNsNV2PeDii-6LAwQCbB2XGEHTJDwkkvyWg@mail.gmail.com>
	<CA+ZOOTM9KkOYJ5Nf25_x1fT+f76xMsdJRkqjYaABiNK9y3FNXA@mail.gmail.com>
Date: Wed, 2 Jul 2014 17:01:24 -0700
Message-ID: <CAMEtUuw0y+r4v8vFBy=-idhe_tDDga34siF7+SCgRD+H-qamtg@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 08/14] bpf: add eBPF verifier
From: Alexei Starovoitov <ast@plumgrid.com>
To: Chema Gonzalez <chema@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
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

On Wed, Jul 2, 2014 at 4:35 PM, Chema Gonzalez <chema@google.com> wrote:
> On Wed, Jul 2, 2014 at 4:04 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>>>> +       reg = regs + BPF_REG_1; /* 1st arg to a function */
>>>> +       reg->ptr = PTR_TO_CTX;
>>> Wait, doesn't this depend on doing "BPF_MOV64_REG(BPF_REG_CTX,
>>> BPF_REG_ARG1)" (the bpf-to-ebpf prologue), which is only enforced on
>>> filters converted from bpf? In fact, shouldn't this set
>>> regs[BPF_REG_CTX] instead of regs[BPF_REG_1] ?
>>
>> nope. it's REG_1.
>> as you said r6=r1 is only emitted by converted classic filters.
>> Verifier will see this 'r6=r1' assignment and will copy the r1 type into r6.
> You're right. I read BPF_MOV64_REG() AT&T-syntax-style.
>
> BTW, check_stack_write() in kernel/bpf/verifier.c has a couple of
> assignments of a slot->ptr to 0 (instead of INVALID_PTR). I assume
> this is unintended.

yes. good catch. Will fix it.
Too bad C compiler silently casts integers to enums

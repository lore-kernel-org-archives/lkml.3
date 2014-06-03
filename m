Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964822AbaFCU6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:58:25 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:37598 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933299AbaFCU6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:58:22 -0400
MIME-Version: 1.0
In-Reply-To: <538E319B.3000606@redhat.com>
References: <1401692506-7796-1-git-send-email-ast@plumgrid.com>
	<538C3C94.3080206@redhat.com>
	<CAMEtUuzkjZCsReWH9cZs8AU0mJjZH9YOdCBTWusxe6-NZ9mQ=g@mail.gmail.com>
	<538CAEA6.4060307@redhat.com>
	<CAMEtUuwxJOgYgFjg9deQZOffeg6-JUGZXZ1Rj344eQmriQ0F0Q@mail.gmail.com>
	<538D8DAA.7090105@redhat.com>
	<CAMEtUuw8uyCGeLeUB0PXm5cCpqcsjPLZt6y9FcKjapbVPjWTuw@mail.gmail.com>
	<538E319B.3000606@redhat.com>
Date: Tue, 3 Jun 2014 13:58:21 -0700
Message-ID: <CAMEtUuzsHJioXZtuGje6UmwZmcmDZEn8PdkkYanA9j1sp242+Q@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 0/2] split BPF out of core networking
From: Alexei Starovoitov <ast@plumgrid.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2014 at 1:35 PM, Daniel Borkmann <dborkman@redhat.com> wrote:
> On 06/03/2014 05:44 PM, Alexei Starovoitov wrote:
> ...
>>
>> All of your points are valid. They are right questions to ask. I just
>>
>> don't see why you're still arguing about first step of filter.c split,
>> whereas your concerns are about steps 2, 3, 4.
>
>
> Fair enough, lets keep them in mind though for future work. Btw,

Ok :)

> are other files planned for kernel/bpf/ or should it instead just
> simply be kernel/bpf.c?

The most obvious one is eBPF verifier in separate file (kernel/bpf/verifier.c)
bpf maps is yet another thing, but that's different topic.
Probably a set of bpf-callable functions in another file. Like right now
for sockets these helpers are __skb_get_pay_offset(), __skb_get_nlattr()
For tracing there will be a different set of helper functions and eventually
some will be common. Like __get_raw_cpu_id() from filter.c could
eventually move to kernel/bpf/helpers.c
I'm not a fan of squeezing different logic into one file.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbaHOTfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:35:24 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:63983 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaHOTfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:35:22 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrUqop+UB-BhyX4Y41kELO+6kcFdS1F7ZyN0CzRwg4UGhA@mail.gmail.com>
References: <1407916658-8731-1-git-send-email-ast@plumgrid.com>
	<1407916658-8731-18-git-send-email-ast@plumgrid.com>
	<CAE40pdf0pNYyazjpdkzxNJi7iC4LOOr_XEu078OUqP_uoCXnHg@mail.gmail.com>
	<CAMEtUuymPDhYBe42i4DJNXsdgZRaq9LuEU_nGSsqrY1FcFHqhQ@mail.gmail.com>
	<CALCETrVH8KXr8uSHAVy5eBsqmi1LjB5QZpboAGcjYswXvW1opA@mail.gmail.com>
	<CAMEtUuzey7PanznrAguOpvPLxyhgJB++ovE8RNys7srs=EY1qg@mail.gmail.com>
	<CALCETrVhjO5c7ob1vntx031c5RmxRHimkRt1F2EsmzdKB53_NA@mail.gmail.com>
	<CAMEtUuzT53jeH-L+saW-RopSR2EERO5UKVHyeORTGHVMCHbYag@mail.gmail.com>
	<CALCETrUNvg88_VrwE+9RKnSgts=3zVcXbX6tuNLgUxJU436CrQ@mail.gmail.com>
	<CAMEtUuwF2_+qzkaW6rkw9cyYJ2eb01B_ZyBcwrJ7nd+GqN5-mQ@mail.gmail.com>
	<CALCETrUqop+UB-BhyX4Y41kELO+6kcFdS1F7ZyN0CzRwg4UGhA@mail.gmail.com>
Date: Fri, 15 Aug 2014 12:35:20 -0700
Message-ID: <CAMEtUuzbP5iUjGZaRxE=gmthpdL37HJkGcOnO5Jxa_7ESGkkgg@mail.gmail.com>
Subject: Re: [PATCH RFC v4 net-next 17/26] tracing: allow eBPF programs to be
 attached to events
From: Alexei Starovoitov <ast@plumgrid.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel Borkmann <dborkman@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Kees Cook <keescook@chromium.org>,
        Network Development <netdev@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 12:18 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> clang/llvm has no problem with u64 :)
>> This bpf_context struct for tracing is trying to answer the question:
>>  'what's the most convenient way to access tracepoint arguments
>> from a script'.
>> When kernel code has something like:
>>  trace_kfree_skb(skb, net_tx_action);
>> the script needs to be able to access this 'skb' and 'net_tx_action'
>> values through _single_ data structure.
>> In this proposal they are ctx->arg1 and ctx->arg2.
>> I've considered having different bpf_context's for every event, but
>> the complexity explodes. I need to hack all event definitions and so on.
>> imo it's better to move complexity to userspace, so program author
>> or high level language abstracts these details.
>
> I still don't understand why making them long instead of u64 is
> helpful, though.  I feel like I'm missing obvious here.

I promise to come back to this... Have to go off grid...
will think of it in the mean time... Appreciate this discussion!!

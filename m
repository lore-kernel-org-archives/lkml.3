Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbaCDRxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 12:53:05 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:58960 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaCDRxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 12:53:03 -0500
MIME-Version: 1.0
In-Reply-To: <20140304142824.GA1083@localhost.localdomain>
References: <1393910304-4004-1-git-send-email-ast@plumgrid.com>
	<1393910304-4004-2-git-send-email-ast@plumgrid.com>
	<20140304142824.GA1083@localhost.localdomain>
Date: Tue, 4 Mar 2014 09:53:01 -0800
Message-ID: <CAMEtUuxHgcroQBPLFa9U=df6KznwkjARin8a3RfH4MdbB2rc7g@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 1/3] Extended BPF interpreter and converter
From: Alexei Starovoitov <ast@plumgrid.com>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Jesse Gross <jesse@nicira.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Pekka Enberg <penberg@iki.fi>, Arjan van de Ven <arjan@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2014 at 6:28 AM, Hagen Paul Pfeifer <hagen@jauu.net> wrote:
> If all issues raised by Daniel are addresed:
>
> Acked-by: Hagen Paul Pfeifer <hagen@jauu.net>

Thanks!

> But ...
>
>>Future work:
>>
>>0. seccomp
>>
>>1. add extended BPF JIT for x86_64
>>
>>2. add inband old/new demux and extended BPF verifier, so that new programs
>>   can be loaded through old sk_attach_filter() and sk_unattached_filter_create()
>>   interfaces
>>
>>3. tracing filters systemtap-like with extended BPF
>>
>>4. OVS with extended BPF
>>
>>5. nftables with extended BPF
>
> ... this is shit (not your fault). (Jitted) BPF envolved into a direction
> which is just not the right way to do it. You try to fix things, bypass
> architectural shortcomings of BPF, perf issues because and so on.
>
> The right direction is to write a new general purpose in-kernel interpreter
> from scratch. Capability layers should provide an compatible API for BPF and
> seccomp. You have the knowledge to do exactly this, you nearly already did
> this - you should start this undertake!

this insn set evolved over few years.
Initially we had nft-like high level state machine, but it wasn't fast,
then kprobe-like pure x86_64 which was fast, but very hard to analyze
from safety point of view. Then reduced x86-64 insn set and finally ebpf.
I think any brand new instruction set will have steep learning curve,
just because
it's all new. ebpf tries to reuse as much as possible. opcode encoding
is the same,
instruction size is fixed at 8 bytes and so on. Yeah, these
restrictions make few
things not 100% optimal, but imo common look and feel is more important.
What ebpf has already should be enough to do all of the above 'future work'.
Built-in JIT-ability of ebpf is the key to performance.
Ability to call some kernel functions from ebpf make it ultimately extensible.
socket filters and seccomp don't use this feature yet, but tracing filters will.

Regards,
Alexei

>
> --
> Hagen Paul Pfeifer

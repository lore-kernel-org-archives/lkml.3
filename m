Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbaCLWQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 18:16:18 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:33984 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbaCLWQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 18:16:16 -0400
MIME-Version: 1.0
In-Reply-To: <1394512892-5448-2-git-send-email-ast@plumgrid.com>
References: <1394512892-5448-1-git-send-email-ast@plumgrid.com>
	<1394512892-5448-2-git-send-email-ast@plumgrid.com>
Date: Wed, 12 Mar 2014 15:16:15 -0700
Message-ID: <CAHA+R7P=XAWAPkJTZSfHs02-+V+VOMQ04ZNNjY6LmPdRENzCJA@mail.gmail.com>
Subject: Re: [PATCH v9 net-next 1/3] filter: add Extended BPF interpreter and converter
From: Cong Wang <cwang@twopensource.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Will Drewry <wad@chromium.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Hagen Paul Pfeifer <hagen@jauu.net>,
        Jesse Gross <jesse@nicira.com>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Pekka Enberg <penberg@iki.fi>, Arjan van de Ven <arjan@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry for jumping into this thread late.)

On Mon, Mar 10, 2014 at 9:41 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>
> 3. tracing filters systemtap-like with extended BPF
>
> 4. OVS with extended BPF
>
> 5. nftables with extended BPF

If you plan to use extended BPF out of networking, does
it make sense to make it independent of networking?
That is, rename those sk_*() APIs?

>
> +int bpf_ext_enable __read_mostly;
> +

This could be converted to a jump label, no?

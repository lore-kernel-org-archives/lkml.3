Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaCIOp6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 10:45:58 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:51550 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbaCIOp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 10:45:56 -0400
Message-ID: <1394376353.20149.96.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH v7 net-next 1/3] filter: add Extended BPF interpreter
 and converter
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Will Drewry <wad@chromium.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Hagen Paul Pfeifer <hagen@jauu.net>,
        Jesse Gross <jesse@nicira.com>, Thomas Gleixner <tglx@linutronix.de>,
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
Date: Sun, 09 Mar 2014 07:45:53 -0700
In-Reply-To: <1394320530-3508-2-git-send-email-ast@plumgrid.com>
References: <1394320530-3508-1-git-send-email-ast@plumgrid.com>
	 <1394320530-3508-2-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-08 at 15:15 -0800, Alexei Starovoitov wrote:

> +/**
> + *	sk_run_filter_ext - run an extended filter
> + *	@ctx: buffer to run the filter on
> + *	@insn: filter to apply
> + *
> + * Decode and execute extended BPF instructions.
> + * @ctx is the data we are operating on.
> + * @filter is the array of filter instructions.
> + */
> +notrace u32 sk_run_filter_ext(void *ctx, const struct sock_filter_ext *insn)
> +{
> +	u64 stack[64];
> +	u64 regs[16];
> +	void *ptr;
> +	u64 tmp;
> +	int off;

Why is this 'notrace' ?

80 u64 on the stack, that is 640 bytes to run a filter ????



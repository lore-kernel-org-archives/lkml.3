Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab3LDAsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 19:48:52 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44187 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab3LDAsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 19:48:50 -0500
Message-ID: <529E7BEC.70509@hitachi.com>
Date: Wed, 04 Dec 2013 09:48:44 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [RFC PATCH tip 4/5] use BPF in tracing filters
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com> <1386044930-15149-5-git-send-email-ast@plumgrid.com>
In-Reply-To: <1386044930-15149-5-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/03 13:28), Alexei Starovoitov wrote:
> Such filters can be written in C and allow safe read-only access to
> any kernel data structure.
> Like systemtap but with safety guaranteed by kernel.
> 
> The user can do:
> cat bpf_program > /sys/kernel/debug/tracing/.../filter
> if tracing event is either static or dynamic via kprobe_events.
> 
> The program can be anything as long as bpf_check() can verify its safety.
> For example, the user can create kprobe_event on dst_discard()
> and use logically following code inside BPF filter:
>       skb = (struct sk_buff *)ctx->regs.di;
>       dev = bpf_load_pointer(&skb->dev);
> to access 'struct net_device'
> Since its prototype is 'int dst_discard(struct sk_buff *skb);'
> 'skb' pointer is in 'rdi' register on x86_64
> bpf_load_pointer() will try to fetch 'dev' field of 'sk_buff'
> structure and will suppress page-fault if pointer is incorrect.

Hmm, I doubt it is a good way to integrate with ftrace.
I prefer to use this for replacing current ftrace filter,
fetch functions and actions. In that case, we can continue
to use current interface but much faster to trace.
Also, we can see what filter/arguments/actions are set
on each event.

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbaGITW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:22:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:34828 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755369AbaGITW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:22:26 -0400
Date: Wed, 9 Jul 2014 15:22:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] tracing: add TRACE_ITER_PRINTK flag check in
 __trace_puts/__trace_bputs
Message-ID: <20140709152216.1df92aa4@gandalf.local.home>
In-Reply-To: <51E7A7D6.8090900@huawei.com>
References: <51E7A7D6.8090900@huawei.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jul 2013 16:31:18 +0800
"zhangwei(Jovi)" <jovi.zhangwei@huawei.com> wrote:

> There missed TRACE_ITER_PRINTK check in __trace_puts/__trace_bputs,
> so add it, to constant with __trace_printk/__trace_bprintk,
> those functions mainly called by same function: trace_printk.

Looks good, I'll add this to my 3.17 queue too.

-- Steve

> 
> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> ---
>  kernel/trace/trace.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 4d70cc5..41340c3 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -365,6 +365,9 @@ int __trace_puts(unsigned long ip, const char *str, int size)
>  	int alloc;
>  	int pc;
> 
> +	if (!(trace_flags & TRACE_ITER_PRINTK))
> +		return 0;
> +
>  	pc = preempt_count();
> 
>  	alloc = sizeof(*entry) + size + 2; /* possible \n added */
> @@ -409,6 +412,9 @@ int __trace_bputs(unsigned long ip, const char *str)
>  	int size = sizeof(struct bputs_entry);
>  	int pc;
> 
> +	if (!(trace_flags & TRACE_ITER_PRINTK))
> +		return 0;
> +
>  	pc = preempt_count();
> 
>  	local_save_flags(irq_flags);


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab3GASzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 14:55:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2267 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3GASzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 14:55:18 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=wJKLB0u9QJoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Gd3SYs88-wcA:10 a=20KFwNOVAAAA:8 a=wtPHUAWxu9G6XHarHd0A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372704916.22688.12.camel@gandalf.local.home>
Subject: Re: [PATCH v2 3/4] tracing/kprobes: Don't pass addr=ip to
 perf_trace_buf_submit()
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 01 Jul 2013 14:55:16 -0400
In-Reply-To: <20130620173811.GA13161@redhat.com>
References: <20130620173811.GA13161@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 19:38 +0200, Oleg Nesterov wrote:
> kprobe_perf_func() and kretprobe_perf_func() pass addr=ip to
> perf_trace_buf_submit() for no reason.
> 
> This sets perf_sample_data->addr for PERF_SAMPLE_ADDR, we already
> have perf_sample_data->ip initialized if PERF_SAMPLE_IP.

This change log is confusing. I have no idea what this is trying to fix.
Can you explain what is the issue here and what this change fixes.

Thanks,

-- Steve

> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace_kprobe.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 3432652..141c682 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1163,8 +1163,7 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
>  	entry->ip = (unsigned long)tp->rp.kp.addr;
>  	memset(&entry[1], 0, dsize);
>  	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
> -	perf_trace_buf_submit(entry, size, rctx,
> -					entry->ip, 1, regs, head, NULL);
> +	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
>  }
>  
>  /* Kretprobe profile handler */
> @@ -1197,8 +1196,7 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
>  	entry->func = (unsigned long)tp->rp.kp.addr;
>  	entry->ret_ip = (unsigned long)ri->ret_addr;
>  	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
> -	perf_trace_buf_submit(entry, size, rctx,
> -					entry->ret_ip, 1, regs, head, NULL);
> +	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
>  }
>  #endif	/* CONFIG_PERF_EVENTS */
>  



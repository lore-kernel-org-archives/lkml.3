Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965028Ab3GSB3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 21:29:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3484 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759284Ab3GSB3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 21:29:32 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=GZfv41eBbK4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=WXzlLm9s7TAA:10 a=NGtMB0m1luFT4yXXlg0A:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374197370.3356.8.camel@gandalf.local.home>
Subject: Re: [PATCH 2/3] tracing: use trace_seq_puts()/trace_seq_putc()
 where possible
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 18 Jul 2013 21:29:30 -0400
In-Reply-To: <51E3B3AC.1000605@huawei.com>
References: <51E3B3AC.1000605@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 16:32 +0800, zhangwei(Jovi) wrote:
> diff --git a/kernel/trace/trace_functions_graph.c
> b/kernel/trace/trace_functions_graph.c
> index 8388bc9..3793f90 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -446,7 +446,7 @@ print_graph_proc(struct trace_seq *s, pid_t pid)
> 
>         /* First spaces to align center */
>         for (i = 0; i < spaces / 2; i++) {
> -               ret = trace_seq_printf(s, " ");
> +               ret = trace_seq_putc(s, ' ');
>                 if (!ret)
>                         return TRACE_TYPE_PARTIAL_LINE;
>         }
> @@ -457,7 +457,7 @@ print_graph_proc(struct trace_seq *s, pid_t pid)
> 
>         /* Last spaces to align center */
>         for (i = 0; i < spaces - (spaces / 2); i++) {
> -               ret = trace_seq_printf(s, " ");
> +               ret = trace_seq_putc(s, " ");

Oops, s/"/'/g

I'll fix it.

-- Steve

>                 if (!ret)
>                         return TRACE_TYPE_PARTIAL_LINE;
>         }
> @@ -503,7 +503,7 @@ verif_pid(struct trace_seq *s, pid_t pid, int cpu,
> struct fgraph_data *data)
> 
> 


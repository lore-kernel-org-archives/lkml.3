Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab3CBERm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 23:17:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9625 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab3CBERl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 23:17:41 -0500
X-Authority-Analysis: v=2.0 cv=It2cgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=i_T0xk-kDUsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=9MfQyeY-N7UA:10 a=i0EeH86SAAAA:8 a=XFyvp_UXoxGQGQ9I_6oA:9 a=PUjeQqilurYA:10 a=hPjdaMEvmhQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362197859.1231.81.camel@gandalf.local.home>
Subject: Re: [PATCH 4/4] tracing/syscalls: Annotate field-defining functions
 with __init
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 01 Mar 2013 23:17:39 -0500
In-Reply-To: <51258796.7020704@huawei.com>
References: <51258723.2040301@huawei.com> <51258796.7020704@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-21 at 10:33 +0800, Li Zefan wrote:
> These two functions are called during kernel boot only.
> 

Applied, thanks Li!

-- Steve

> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
>  kernel/trace/trace_syscalls.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 5329e13..a70fa19 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -232,7 +232,7 @@ static void free_syscall_print_fmt(struct ftrace_event_call *call)
>  		kfree(call->print_fmt);
>  }
>  
> -static int syscall_enter_define_fields(struct ftrace_event_call *call)
> +static int __init syscall_enter_define_fields(struct ftrace_event_call *call)
>  {
>  	struct syscall_trace_enter trace;
>  	struct syscall_metadata *meta = call->data;
> @@ -255,7 +255,7 @@ static int syscall_enter_define_fields(struct ftrace_event_call *call)
>  	return ret;
>  }
>  
> -static int syscall_exit_define_fields(struct ftrace_event_call *call)
> +static int __init syscall_exit_define_fields(struct ftrace_event_call *call)
>  {
>  	struct syscall_trace_exit trace;
>  	int ret;



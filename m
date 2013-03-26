Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173Ab3CZTKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:10:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11992 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab3CZTKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:10:16 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=gPDFDwPFkwsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=T1ZKc6cXkYkA:10 a=a_U1oVfrAAAA:8 a=ibGu6BooI162UXAdWHYA:9 a=QEXdDO2ut3YA:10 a=k4qQewaewV0A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1364325014.6345.195.camel@gandalf.local.home>
Subject: Re: [PATCH] ftrace: Consistently restore trace function on sysctl
 enabling
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Tue, 26 Mar 2013 15:10:14 -0400
In-Reply-To: <5151D26F.1070702@siemens.com>
References: <5151D26F.1070702@siemens.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-26 at 17:53 +0100, Jan Kiszka wrote:
> If we reenable ftrace via syctl, we currently set ftrace_trace_function
> based on the previous simplistic algorithm. This is inconsistent with
> what update_ftrace_function does. So better call that helper instead.
> 
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>  kernel/trace/ftrace.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 62b71f6..b9b90f0 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -4538,12 +4538,8 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
>  		ftrace_startup_sysctl();
>  
>  		/* we are starting ftrace again */
> -		if (ftrace_ops_list != &ftrace_list_end) {
> -			if (ftrace_ops_list->next == &ftrace_list_end)
> -				ftrace_trace_function = ftrace_ops_list->func;
> -			else
> -				ftrace_trace_function = ftrace_ops_list_func;
> -		}

I remember there was a reason why I didn't update this, but I can't
remember why. Looking at it now, it doesn't look like there is a reason.

I'll have to think about this one more. Another score for not
commenting :-p

Thanks,

-- Steve

> +		if (ftrace_ops_list != &ftrace_list_end)
> +			update_ftrace_function();
>  
>  	} else {
>  		/* stopping ftrace calls (just send to ftrace_stub) */



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092Ab3GRQkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:40:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12445 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758887Ab3GRQkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:40:32 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=OBo3vzDK1icA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=GDUt3bqODRQA:10 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=HmXPV2sSyQM2aKoY0MgA:9 a=QEXdDO2ut3YA:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374165631.6458.248.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2] tracing: Fix error handling to ensure instances can
 always be removed
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexander Z Lam <azl@google.com>
Cc: linux-kernel@vger.kernel.org, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>
Date: Thu, 18 Jul 2013 12:40:31 -0400
In-Reply-To: <1373502874-1706-2-git-send-email-azl@google.com>
References: <1373502874-1706-1-git-send-email-azl@google.com>
	 <1373502874-1706-2-git-send-email-azl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-10 at 17:34 -0700, Alexander Z Lam wrote:
> Remove debugfs directories for tracing instances during creation if an error
> occurs causing the trace_array for that instance to not be added to
> ftrace_trace_arrays. If the directory continues to exist after the error, it
> cannot be removed because the respective trace_array is not in
> ftrace_trace_arrays.

This patch is fine, I'll put it in now.

Thanks,

-- Steve

> 
> Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
> Cc: David Sharp <dhsharp@google.com>
> Cc: Alexander Z Lam <lambchop468@gmail.com>
> Signed-off-by: Alexander Z Lam <azl@google.com>
> ---
>  kernel/trace/trace.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index ca2743b..4ea9967 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -5985,8 +5985,10 @@ static int new_instance_create(const char *name)
>  		goto out_free_tr;
>  
>  	ret = event_trace_add_tracer(tr->dir, tr);
> -	if (ret)
> +	if (ret) {
> +		debugfs_remove_recursive(tr->dir);
>  		goto out_free_tr;
> +	}
>  
>  	init_tracer_debugfs(tr, tr->dir);
>  



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab3E1TcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 15:32:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10659 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab3E1Tb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 15:31:59 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ggpWy2Hc9ZsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=dYF8XoAgN1cA:10 a=pGLkceISAAAA:8 a=ytI36I5-DyDJJBDCWu4A:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=FmMGMGGnQ22dFWGS:21 a=TJF-A9EFPkkitkSr:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369769517.15552.17.camel@gandalf.local.home>
Subject: Re: [PATCH] tracing: Fix file mode of free_buffer
From: Steven Rostedt <rostedt@goodmis.org>
To: Wang YanQing <udknight@gmail.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        vnagarnaik@google.com, David Sharp <dhsharp@google.com>
Date: Tue, 28 May 2013 15:31:57 -0400
In-Reply-To: <20130526085201.GA3183@udknight>
References: <20130526085201.GA3183@udknight>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David, Vaibhav,

Any comments on this patch?

-- Steve


On Sun, 2013-05-26 at 16:52 +0800, Wang YanQing wrote:
> Commit 4f271a2a60c748599b30bb4dafff30d770439b96
> (tracing: Add a proc file to stop tracing and free buffer)
> implement a method to free up ring buffer in kernel memory
> in the release code path of free_buffer's fd.
> 
> Then we don't need read/write support for free_buffer,
> indeed we just have a dummy write fop, and don't implement read fop.
> 
> So the 0200 is more reasonable file mode for free_buffer than
> the current file mode 0644.
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  kernel/trace/trace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index ae6fa2d..02d9875 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -5927,7 +5927,7 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
>  	trace_create_file("buffer_total_size_kb", 0444, d_tracer,
>  			  tr, &tracing_total_entries_fops);
>  
> -	trace_create_file("free_buffer", 0644, d_tracer,
> +	trace_create_file("free_buffer", 0200, d_tracer,
>  			  tr, &tracing_free_buffer_fops);
>  
>  	trace_create_file("trace_marker", 0220, d_tracer,



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbaCSCPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 22:15:37 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:14415 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757623AbaCSCPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 22:15:36 -0400
Date: Tue, 18 Mar 2014 22:15:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com
Subject: Re: [PATCH 1/3 Resend] tracing: Use inline task_nice() to get rid
 of an open coded implementation of it.
Message-ID: <20140318221533.45c479bd@gandalf.local.home>
In-Reply-To: <6188b0062bdba8e3170b09c88fac6004a8f6fa7c.1394619587.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394619587.git.yangds.fnst@cn.fujitsu.com>
	<6188b0062bdba8e3170b09c88fac6004a8f6fa7c.1394619587.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014 18:26:42 +0800
Dongsheng Yang <yangds.fnst@cn.fujitsu.com> wrote:

> Function task_nice() was reimplemented as inline function, we can use it here
> to replace the open coded implementation.
> 
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 815c878..dba0e3d 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1003,7 +1003,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
>  	else
>  		max_data->uid = task_uid(tsk);
>  
> -	max_data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
> +	max_data->nice = task_nice(tsk);

task_nice() is still an extern function in mainline, and this is the
tracing side. I rather wait till it becomes inline in Linus's tree
before I take this.

-- Steve

>  	max_data->policy = tsk->policy;
>  	max_data->rt_priority = tsk->rt_priority;
>  


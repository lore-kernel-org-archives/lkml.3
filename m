Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaBKDTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 22:19:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:38953 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbaBKDTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 22:19:38 -0500
X-IronPort-AV: E=Sophos;i="4.95,822,1384272000"; 
   d="scan'208";a="9503723"
Message-ID: <52F996BF.402@cn.fujitsu.com>
Date: Tue, 11 Feb 2014 11:19:27 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com
Subject: Re: [PATCH] tracing: Use task_nice() in function __update_max_tr()
 to get the nice value of task.
References: <1390430505-17234-1-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1390430505-17234-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/11 11:17:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/11 11:17:37,
	Serialize complete at 2014/02/11 11:17:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,
     As my patch to implement task_nice() as inline function was applied 
to tip tree.
http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=d0ea026808ad81de2af14938448419a95211b938

     Please consider to apply this patch in this thread. Thanx :)

On 01/23/2014 06:41 AM, Dongsheng Yang wrote:
> There is already a function named task_nice in sched.h to get the nice value
> of task_struct. We can use it in __update_max_tr() rather than calculate it
> manually.
>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>   kernel/trace/trace.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 9d20cd9..ec149b4 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -970,7 +970,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
>   	else
>   		max_data->uid = task_uid(tsk);
>   
> -	max_data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
> +	max_data->nice = task_nice(tsk);
>   	max_data->policy = tsk->policy;
>   	max_data->rt_priority = tsk->rt_priority;
>   


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaCKFTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 01:19:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43489 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbaCKFTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 01:19:18 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9676536"
Message-ID: <531E9968.8010401@cn.fujitsu.com>
Date: Tue, 11 Mar 2014 13:04:40 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        Steven Rostedt <rostedt@goodmis.org>, peterz@infradead.org,
        mingo@redhat.com
Subject: Re: [PATCH 1/3] tracing: Use inline task_nice() to get rid of an
 open coded implementation of it.
References: <8ae8a3aefb157e9e7d1b62a4c136289e74783eaf.1394022835.git.yangds.fnst@cn.fujitsu.com>
In-Reply-To: <8ae8a3aefb157e9e7d1b62a4c136289e74783eaf.1394022835.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 13:03:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 13:16:33,
	Serialize complete at 2014/03/11 13:16:33
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi steve,
     Could you take these three patches if they looks fine to you??

Thanx

On 03/05/2014 08:36 PM, Dongsheng Yang wrote:
> Function task_nice() was reimplemented as inline function, we can use it here
> to replace the open coded implementation.
>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>   kernel/trace/trace.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 815c878..dba0e3d 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1003,7 +1003,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
>   	else
>   		max_data->uid = task_uid(tsk);
>   
> -	max_data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
> +	max_data->nice = task_nice(tsk);
>   	max_data->policy = tsk->policy;
>   	max_data->rt_priority = tsk->rt_priority;
>   


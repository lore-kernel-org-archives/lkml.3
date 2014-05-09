Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbaEIBRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 21:17:18 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:14884 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754410AbaEIBRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 21:17:17 -0400
X-IronPort-AV: E=Sophos;i="4.97,1014,1389715200"; 
   d="scan'208";a="30283094"
Message-ID: <536C1E97.3080701@cn.fujitsu.com>
Date: Fri, 9 May 2014 09:17:27 +0900
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: <rostedt@goodmis.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] tracing: Use inline task_nice() to get rid of
 an open coded implementation of it.
References: <20140318221533.45c479bd@gandalf.local.home> <1399531103-920-1-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1399531103-920-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi steven, as you request, I resend this patch now when function task_nice()
is already in mainline. Do you want to take it?

On 05/08/2014 03:38 PM, Dongsheng Yang wrote:
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
> index 737b0ef..f296adc 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1015,7 +1015,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
>   	else
>   		max_data->uid = task_uid(tsk);
>   
> -	max_data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
> +	max_data->nice = task_nice(tsk);
>   	max_data->policy = tsk->policy;
>   	max_data->rt_priority = tsk->rt_priority;
>   


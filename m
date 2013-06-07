Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab3FGTxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:53:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19601 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab3FGTxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:53:12 -0400
X-Authority-Analysis: v=2.0 cv=H8VZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=EuFNIyaHSgUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=GtgKSTr36qMA:10 a=57SyGIRnAAAA:8 a=VwQbUJbxAAAA:8 a=jMg_Gfg-Gvda8nM5g_EA:9 a=QEXdDO2ut3YA:10 a=TIV7c6GJmisA:10 a=LI9Vle30uBYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370634791.9844.94.camel@gandalf.local.home>
Subject: Re: [PATCH] tracing: Do not call kmem_cache_free() on allocation
 failure
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Fri, 07 Jun 2013 15:53:11 -0400
In-Reply-To: <1370585268-29169-1-git-send-email-namhyung@kernel.org>
References: <1370585268-29169-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-07 at 15:07 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> There's no point calling it when _alloc() failed.

Thanks, I queued this up for 3.11 as it's not that important for a late
-rc release.

-- Steve

> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/trace_events.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 27963e2bf4bf..bb4950b552b5 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -97,7 +97,7 @@ static int __trace_define_field(struct list_head *head, const char *type,
>  
>  	field = kmem_cache_alloc(field_cachep, GFP_TRACE);
>  	if (!field)
> -		goto err;
> +		return -ENOMEM;
>  
>  	field->name = name;
>  	field->type = type;
> @@ -114,11 +114,6 @@ static int __trace_define_field(struct list_head *head, const char *type,
>  	list_add(&field->link, head);
>  
>  	return 0;
> -
> -err:
> -	kmem_cache_free(field_cachep, field);
> -
> -	return -ENOMEM;
>  }
>  
>  int trace_define_field(struct ftrace_event_call *call, const char *type,



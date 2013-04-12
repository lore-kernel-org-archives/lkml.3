Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab3DLSNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 14:13:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31115 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab3DLSNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 14:13:17 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=KTmiORCV4U8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=ozPQQfBhc10A:10 a=57SyGIRnAAAA:8 a=VwQbUJbxAAAA:8 a=2ySQTwxOyORc7gUD1osA:9 a=QEXdDO2ut3YA:10 a=TIV7c6GJmisA:10 a=LI9Vle30uBYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365790396.9609.93.camel@gandalf.local.home>
Subject: Re: [PATCH v2 2/2] tracing: Reset ftrace_graph_filter_enabled if
 count is zero
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Fri, 12 Apr 2013 14:13:16 -0400
In-Reply-To: <1365663698-2413-1-git-send-email-namhyung@kernel.org>
References: <1365663302-2170-2-git-send-email-namhyung@kernel.org>
	 <1365663698-2413-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 16:01 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The ftrace_graph_count can be decreased with a "!" pattern, so that
> the enabled flag should be updated too.

Thanks!

Once again I'll push patch 1 to 3.9 and stable as that's a nasty bug.

But this patch isn't that big of a deal, and as we are in the later
-rc's I'll label it with stable and add it to the 3.10 queue.

Thanks,

-- Steve

> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/ftrace.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index be2bcb7ab2f7..daf8df20b764 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -3779,7 +3779,8 @@ out:
>  	if (fail)
>  		return -EINVAL;
>  
> -	ftrace_graph_filter_enabled = 1;
> +	ftrace_graph_filter_enabled = !!(*idx);
> +
>  	return 0;
>  }
>  



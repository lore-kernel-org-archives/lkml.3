Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936182Ab3DIPA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 11:00:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2387 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760658Ab3DIPA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 11:00:28 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=7_l8aGtSdH4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=YEqtQkbJdgYA:10 a=40MIqcmNAAAA:8 a=woh94gcO0G0T0jqpc7AA:9 a=QEXdDO2ut3YA:10 a=-tENaG0q7zQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365519626.25498.58.camel@gandalf.local.home>
Subject: Re: [PATCH] kernel: trace: ftrace: strncpy, using strlcpy instead
 of strncpy
From: Steven Rostedt <rostedt@goodmis.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 09 Apr 2013 11:00:26 -0400
In-Reply-To: <516243B7.9020405@asianux.com>
References: <516243B7.9020405@asianux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll queue this up for my 3.10 queue. I'm going to merge this patch with
the previous patch you sent that updates trace.c

Thanks,

-- Steve

On Mon, 2013-04-08 at 12:12 +0800, Chen Gang wrote:
>   for NUL terminated string, need always set '\0' at the end.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/trace/ftrace.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index dfd33f0..fa984b7 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -3492,14 +3492,14 @@ static char ftrace_filter_buf[FTRACE_FILTER_SIZE] __initdata;
>  
>  static int __init set_ftrace_notrace(char *str)
>  {
> -	strncpy(ftrace_notrace_buf, str, FTRACE_FILTER_SIZE);
> +	strlcpy(ftrace_notrace_buf, str, FTRACE_FILTER_SIZE);
>  	return 1;
>  }
>  __setup("ftrace_notrace=", set_ftrace_notrace);
>  
>  static int __init set_ftrace_filter(char *str)
>  {
> -	strncpy(ftrace_filter_buf, str, FTRACE_FILTER_SIZE);
> +	strlcpy(ftrace_filter_buf, str, FTRACE_FILTER_SIZE);
>  	return 1;
>  }
>  __setup("ftrace_filter=", set_ftrace_filter);



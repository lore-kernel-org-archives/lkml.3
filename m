Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbaBVJIn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 04:08:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:42823 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbaBVJHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 04:07:05 -0500
X-IronPort-AV: E=Sophos;i="4.97,523,1389715200"; 
   d="scan'208";a="9582025"
Message-ID: <53086860.2010209@cn.fujitsu.com>
Date: Sat, 22 Feb 2014 17:05:36 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 9/9] trace: Replace hardcoding of 19 with MAX_NICE.
References: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com> <eeb2a85d74c71e0d50c88789f99ad857a6b4b7b4.1392103744.git.yangds.fnst@cn.fujitsu.com>
In-Reply-To: <eeb2a85d74c71e0d50c88789f99ad857a6b4b7b4.1392103744.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/22 17:04:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/22 17:04:47,
	Serialize complete at 2014/02/22 17:04:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter.
     It seems the all other patches in this set were all applied to tip 
except this one.
What is the problem with the [9/9]? Is there any thing I can do?

Thanx


On 02/11/2014 03:34 PM, Dongsheng Yang wrote:
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> cc: Steven Rostedt <rostedt@goodmis.org>
> cc: Frederic Weisbecker <fweisbec@gmail.com>
> cc: Ingo Molnar <mingo@redhat.com>
> ---
>   kernel/trace/ring_buffer_benchmark.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
> index a5457d5..0434ff1 100644
> --- a/kernel/trace/ring_buffer_benchmark.c
> +++ b/kernel/trace/ring_buffer_benchmark.c
> @@ -40,8 +40,8 @@ static int write_iteration = 50;
>   module_param(write_iteration, uint, 0644);
>   MODULE_PARM_DESC(write_iteration, "# of writes between timestamp readings");
>   
> -static int producer_nice = 19;
> -static int consumer_nice = 19;
> +static int producer_nice = MAX_NICE;
> +static int consumer_nice = MAX_NICE;
>   
>   static int producer_fifo = -1;
>   static int consumer_fifo = -1;
> @@ -308,7 +308,7 @@ static void ring_buffer_producer(void)
>   
>   	/* Let the user know that the test is running at low priority */
>   	if (producer_fifo < 0 && consumer_fifo < 0 &&
> -	    producer_nice == 19 && consumer_nice == 19)
> +	    producer_nice == MAX_NICE && consumer_nice == MAX_NICE)
>   		trace_printk("WARNING!!! This test is running at lowest priority.\n");
>   
>   	trace_printk("Time:     %lld (usecs)\n", time);


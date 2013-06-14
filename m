Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab3FNDDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 23:03:00 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:49482 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3FNDC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 23:02:59 -0400
Message-ID: <51BA87DB.1020403@hitachi.com>
Date: Fri, 14 Jun 2013 12:02:51 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH] tracing/kprobes: remove unnecessary checking of, trace_probe_is_enabled
References: <51BA7B9E.3040807@huawei.com>
In-Reply-To: <51BA7B9E.3040807@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/14 11:10), zhangwei(Jovi) wrote:
> Since tp->flags assignment was moved into function enable_trace_probe,
> so there have no need to use trace_probe_is_enabled to check flags
> in same function.

Indeed :)

> 
> Remove the unnecessary checking.


Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> 
> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
>  kernel/trace/trace_kprobe.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 9f46e98..f237417 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -240,8 +240,7 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
>  	} else
>  		tp->flags |= TP_FLAG_PROFILE;
> 
> -	if (trace_probe_is_enabled(tp) && trace_probe_is_registered(tp) &&
> -	    !trace_probe_has_gone(tp)) {
> +	if (trace_probe_is_registered(tp) && !trace_probe_has_gone(tp)) {
>  		if (trace_probe_is_return(tp))
>  			ret = enable_kretprobe(&tp->rp);
>  		else
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



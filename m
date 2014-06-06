Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaFFBBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 21:01:55 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41873 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaFFBBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 21:01:54 -0400
Message-ID: <539112FC.6070604@hitachi.com>
Date: Fri, 06 Jun 2014 10:01:48 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH ftrace/core 2/3] trace/kprobes: Avoid self tests if tracing
 is disabled on boot up
References: <20140605223515.32311.71203.stgit@yunodevel> <20140605223520.32311.56097.stgit@yunodevel>
In-Reply-To: <20140605223520.32311.56097.stgit@yunodevel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/06 7:35), Yoshihiro YUNOMAE wrote:
> If tracing is disabled on boot up, the kernel should not execute self tests.
> In this patch, the kernel checks whether tracing is disabled or not
> before executing self tests.

Looks good to me, thanks! :)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> 
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: linux-kernel@vger.kernel.org
> ---
>  kernel/trace/trace_kprobe.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 903ae28..ef2fba1 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1377,6 +1377,9 @@ static __init int kprobe_trace_self_tests_init(void)
>  	struct trace_kprobe *tk;
>  	struct ftrace_event_file *file;
>  
> +	if (tracing_is_disabled())
> +		return -ENODEV;
> +
>  	target = kprobe_trace_selftest_target;
>  
>  	pr_info("Testing kprobe tracing: ");
> 
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



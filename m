Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892Ab3LIPLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:11:54 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:42130 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab3LIPLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:11:52 -0500
Message-ID: <52A5DDB1.20708@hitachi.com>
Date: Tue, 10 Dec 2013 00:11:45 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 13/17] tracing/uprobes: Pass 'is_return' to traceprobe_parse_probe_arg()
References: <1386570005-3368-1-git-send-email-namhyung@kernel.org> <1386570005-3368-14-git-send-email-namhyung@kernel.org>
In-Reply-To: <1386570005-3368-14-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/09 15:20), Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Currently uprobes don't pass is_return to the argument parser so that
> it cannot make use of "$retval" fetch method since it only works for
> return probes.

Looks good for me.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/trace_uprobe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 89dd346865ad..d407a556aa55 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -512,7 +512,7 @@ static int create_trace_uprobe(int argc, char **argv)
>  
>  		/* Parse fetch argument */
>  		ret = traceprobe_parse_probe_arg(arg, &tu->tp.size, parg,
> -						 false, false);
> +						 is_return, false);
>  		if (ret) {
>  			pr_info("Parse error at argument[%d]. (%d)\n", i, ret);
>  			goto error;
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



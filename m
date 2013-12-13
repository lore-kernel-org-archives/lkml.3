Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab3LMB64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 20:58:56 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33043 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab3LMB6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 20:58:54 -0500
Message-ID: <52AA69D6.3020705@hitachi.com>
Date: Fri, 13 Dec 2013 10:58:46 +0900
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
Subject: Re: [PATCH 16/17] uprobes: Allocate ->utask before handler_chain()
 for tracing handlers
References: <1386570005-3368-1-git-send-email-namhyung@kernel.org> <1386570005-3368-17-git-send-email-namhyung@kernel.org>
In-Reply-To: <1386570005-3368-17-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/09 15:20), Namhyung Kim wrote:
> From: Oleg Nesterov <oleg@redhat.com>
> 
> uprobe_trace_print() and uprobe_perf_print() need to pass the additional
> info to call_fetch() methods, currently there is no simple way to do this.
> 
> current->utask looks like a natural place to hold this info, but we need
> to allocate it before handler_chain().
> 
> This is a bit unfortunate, perhaps we will find a better solution later,
> but this is simnple and should work right now.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> ---
>  kernel/events/uprobes.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 24b7d6ca871b..3cc8e0bb8acf 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1828,6 +1828,10 @@ static void handle_swbp(struct pt_regs *regs)
>  	if (unlikely(!test_bit(UPROBE_COPY_INSN, &uprobe->flags)))
>  		goto out;
>  
> +	/* Tracing handlers use ->utask to communicate with fetch methods */
> +	if (!get_utask())
> +		goto out;
> +
>  	handler_chain(uprobe, regs);
>  	if (can_skip_sstep(uprobe, regs))
>  		goto out;
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



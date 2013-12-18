Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab3LRUXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 15:23:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:63360 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751126Ab3LRUXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 15:23:42 -0500
Date: Wed, 18 Dec 2013 15:23:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 10/17] tracing/probes: Move 'symbol' fetch method to
 kprobes
Message-ID: <20131218152338.56c10937@gandalf.local.home>
In-Reply-To: <1387168336-13213-11-git-send-email-namhyung@kernel.org>
References: <1387168336-13213-1-git-send-email-namhyung@kernel.org>
	<1387168336-13213-11-git-send-email-namhyung@kernel.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Dec 2013 13:32:09 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> index 5395d37e5e72..adc9ac70fd3c 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -115,6 +115,14 @@ DEFINE_BASIC_FETCH_FUNCS(stack)
>  #define fetch_stack_string_size	NULL
>  
>  
> +/* uprobes don't support symbol fetch methods */

"uprobes does not support symbol fetch methods"

-- Steve

> +#define fetch_symbol_u8			NULL
> +#define fetch_symbol_u16		NULL
> +#define fetch_symbol_u32		NULL
> +#define fetch_symbol_u64		NULL
> +#define fetch_symbol_string		NULL
> +#define fetch_symbol_string_size	NULL
> +
>  /* Fetch type information table */
>  const struct fetch_type uprobes_fetch_type_table[] = {
>  	/* Special types */


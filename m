Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab3H0Lyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 07:54:49 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:52103 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab3H0Lys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 07:54:48 -0400
Message-ID: <521C9385.8070201@hitachi.com>
Date: Tue, 27 Aug 2013 20:54:45 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 13/13] tracing/uprobes: Add support for full argument
 access methods
References: <1377593336-16828-1-git-send-email-namhyung@kernel.org> <1377593336-16828-14-git-send-email-namhyung@kernel.org>
In-Reply-To: <1377593336-16828-14-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/27 17:48), Namhyung Kim wrote:
> @@ -315,13 +316,18 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
>  			ret = -EINVAL;
>  	} else if (strncmp(arg, "stack", 5) == 0) {
>  		if (arg[5] == '\0') {
> -			if (strcmp(t->name, DEFAULT_FETCH_TYPE_STR) == 0)
> -				f->fn = fetch_stack_address;
> -			else
> -				ret = -EINVAL;
> +			if (strcmp(t->name, DEFAULT_FETCH_TYPE_STR))
> +				return -EINVAL;
> +
> +			if (is_kprobe)
> +				f->fn = fetch_kernel_stack_address;
> +			else {
> +				f->fn = t->fetch[FETCH_MTD_stack];
> +				f->data = (void *)0;
> +			}

No, the 'stack' means the address of the stack frame. Perhaps you might make a
new function to retrieve it from pt_regs.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



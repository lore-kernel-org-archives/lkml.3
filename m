Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab3LBREK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 12:04:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab3LBREH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 12:04:07 -0500
Date: Mon, 2 Dec 2013 18:04:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 08/17] tracing/probes: Split [ku]probes_fetch_type_table
Message-ID: <20131202170454.GA28115@redhat.com>
References: <1385533203-10014-1-git-send-email-namhyung@kernel.org> <1385533203-10014-9-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385533203-10014-9-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27, Namhyung Kim wrote:
>
> Use separate fetch_type_table for kprobes and uprobes.  It currently
> shares all fetch methods but some of them will be implemented
> differently later.

Hmm. This looks wrong, afaics...

>  static int parse_probe_arg(char *arg, const struct fetch_type *t,
>  		     struct fetch_param *f, bool is_return, bool is_kprobe)
>  {
> +	const struct fetch_type *ftbl;
>  	unsigned long param;
>  	long offset;
>  	char *tmp;
> -	int ret;
> +	int ret = 0;
>
> -	ret = 0;
> +	ftbl = is_kprobe ? kprobes_fetch_type_table : uprobes_fetch_type_table;

OK, but what if, say, CONFIG_KPROBE_EVENT && !CONFIG_UPROBE_EVENT ?
The kernel won't compile in this case?

Oleg.


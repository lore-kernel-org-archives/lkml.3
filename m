Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbaF3Q55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:57:57 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:37696 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbaF3Q5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:57:54 -0400
Date: Mon, 30 Jun 2014 22:27:46 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] tracing/uprobes: Kill the bogus
 UPROBE_HANDLER_REMOVE code in uprobe_dispatcher()
Message-ID: <20140630165746.GC5619@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140627170116.GA18298@redhat.com>
 <20140627170143.GA18329@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140627170143.GA18329@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14063016-2000-0000-0000-000000C45745
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2014-06-27 19:01:43]:

> I do not know why dd9fa555d7bb "tracing/uprobes: Move argument fetching
> to uprobe_dispatcher()" added the UPROBE_HANDLER_REMOVE, but it looks
> wrong.
> 
> OK, perhaps it makes sense to avoid store_trace_args() if the tracee is
> nacked by uprobe_perf_filter(). But then we should kill the same code
> in uprobe_perf_func() and unify the TRACE/PROFILE filtering (we need to
> do this anyway to mix perf/ftrace). Until then this code actually adds
> the pessimization because uprobe_perf_filter() will be called twice and
> return T in likely case.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

-- 
Thanks and Regards
Srikar Dronamraju


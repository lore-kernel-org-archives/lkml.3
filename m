Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbaF3Q4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:56:34 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:42881 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbaF3Q4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:56:33 -0400
Date: Mon, 30 Jun 2014 22:26:26 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] tracing/uprobes: Revert "Support mix of ftrace and
 perf"
Message-ID: <20140630165626.GA5619@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140627170116.GA18298@redhat.com>
 <20140627170136.GA18319@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140627170136.GA18319@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14063016-9574-0000-0000-00000E9E7B11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2014-06-27 19:01:36]:

> This reverts commit 43fe98913c9f67e3b523615ee3316f9520a623e0.
> 
> This patch is very wrong. Firstly, this change leads to unbalanced
> uprobe_unregister(). Just for example,
> 
> 	# perf probe -x /lib/libc.so.6 syscall
> 	# echo 1 >> /sys/kernel/debug/tracing/events/probe_libc/enable
> 	# perf record -e probe_libc:syscall whatever
> 
> after that uprobe is dead (unregistered) but the user of ftrace/perf
> can't know this, and it looks as if nobody hits this probe.
> 
> This would be easy to fix, but there are other reasons why it is not
> simple to mix ftrace and perf. If nothing else, they can't share the
> same ->consumer.filter. This is fixable too, but probably we need to
> fix the poorly designed uprobe_register() interface first. At least
> "register" and "apply" should be clearly separated.
> 
> Cc: stable@vger.kernel.org # v3.14
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

-- 
Thanks and Regards
Srikar Dronamraju


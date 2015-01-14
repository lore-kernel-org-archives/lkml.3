Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbbANRXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:23:33 -0500
Received: from smtprelay0012.hostedemail.com ([216.40.44.12]:59432 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752139AbbANRXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:23:32 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3872:3874:5007:6261:7875:7903:8660:10004:10400:10848:10967:11026:11232:11658:11914:12438:12517:12519:12663:12740:13069:13148:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: table36_1e98a53b7c058
X-Filterd-Recvd-Size: 1767
Date: Wed, 14 Jan 2015 12:23:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Wang Nan <wangnan0@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mingo@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, paulmck@linux.vnet.ibm.com,
        mathieu.desnoyers@efficios.com,
        xiakaixu 00238161 <xiakaixu@huawei.com>
Subject: Re: [PATCH 1/2] tracing: Move enabling tracepoints to just after
 rcu_init()
Message-ID: <20150114122329.40464fd2@gandalf.local.home>
In-Reply-To: <20150114010905.GA800@sejong>
References: <E1Y9QLr-0000h7-Qw@feisty.vs19.net>
	<54AF53BD.5070303@huawei.com>
	<54B5B478.1020401@huawei.com>
	<20150114010905.GA800@sejong>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015 10:09:05 +0900
Namhyung Kim <namhyung@kernel.org> wrote:


> > >> +
> > >> +void __init trace_event_init(void)
> > >> +{
> > >> +	event_trace_memsetup();
> > >> +	init_ftrace_syscalls();
> > >> +	event_trace_enable();
> > >> +}
> > >> +
> > > 
> > > init_ftrace_syscalls() get called twice by trace_init() and trace_event_init(), some resources are wasted.
> > > At lease one of them can be removed.
> 
> I think it's more natural to keep it in the trace_event_init().

I agree, I'll remove it. I'm fixing another bug that this change caused
to system call events.

-- Steve

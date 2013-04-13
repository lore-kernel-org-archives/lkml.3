Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab3DMSZs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 14:25:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab3DMSZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 14:25:47 -0400
Date: Sat, 13 Apr 2013 20:22:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 0/1] uprobes/perf: Avoid perf_trace_buf_prepare/submit
	if ->perf_events is empty
Message-ID: <20130413182259.GA13760@redhat.com>
References: <20130329181545.GA20697@redhat.com> <20130404142522.GC8986@linux.vnet.ibm.com> <515E4938.6090809@hitachi.com> <20130405150110.GA31300@redhat.com> <51628DF8.6030102@hitachi.com> <20130410145818.GA30670@redhat.com> <516692BF.6070904@hitachi.com> <20130411115921.GA27492@redhat.com> <1365801588.9609.95.camel@gandalf.local.home> <20130413140234.GA32273@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130413140234.GA32273@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13, Oleg Nesterov wrote:
>
> On 04/12, Steven Rostedt wrote:
> >
> > Can you make the necessary changes elsewhere? I talked with Frederic on
> > IRC and he's a bit busy with other work. But he did say he would review
> > changes that you make.
>
> Sure, will be happy to do.

Everything looks trivial except DECLARE_EVENT_CLASS()->perf_trace_*() which
should also check __task != NULL.

In fact this _looks_ simple too, we could move TP_perf_assign() logic into
TP_ARGS(), but probably this is too ugly. I'll try think more.

Oleg.


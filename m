Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab3GDSB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 14:01:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756855Ab3GDSBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 14:01:55 -0400
Date: Thu, 4 Jul 2013 19:57:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v5 typo updated] tracing/uprobes: Support
	ftrace_event_file base multibuffer
Message-ID: <20130704175712.GC2046@redhat.com>
References: <51D51BF7.1000602@huawei.com> <51D51DB6.6020701@huawei.com> <87ppuyzs9x.fsf@sejong.aot.lge.com> <51D52BFA.9030600@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D52BFA.9030600@huawei.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04, zhangwei(Jovi) wrote:
>
> On 2013/7/4 15:41, Namhyung Kim wrote:
> >>
> >> Even though we allow multi-uprobes instances now,
> >> but TP_FLAG_PROFILE/TP_FLAG_TRACE are still mutually exclusive
> >> in probe_event_enable currently, this means we cannot allow
> >> one user is using uprobe-tracer, and another user is using
> >> perf-probe on same uprobe concurrently.
> >> (Perhaps this will be fix in future, kprobe dont't have this
> >> limitation now)
> >
> > So why does this limitation exist?  Didn't we support this kind of thing
> > in the original code?

For no reason.

> Yes, it existed(maybe not exist before uprobe pre-filter work),

No, it was always here and I never understood it.

> because uprobe filter
> is associated with trace_uprobe tightly at present, so we cannot assign
> TP_FLAG_PROFILE/TP_FLAG_TRACE for same trace_uprobe with different filter.

More precisely, TRACE_REG_REGISTER should participate (inc/dec nr_systemwide)
if CONFIG_PERF_EVENTS.

> Perhaps we need to remove the limitation in future.

Yes, I'll remove it.

Oleg.


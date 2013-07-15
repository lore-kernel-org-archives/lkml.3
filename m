Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab3GOSZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:25:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082Ab3GOSZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:25:18 -0400
Date: Mon, 15 Jul 2013 20:20:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>, jovi.zhangwei@huawei.com,
        Jiri Olsa <jolsa@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH V2] tracing/kprobe: Wait for disabling all running
	kprobe handlers
Message-ID: <20130715182012.GB18505@redhat.com>
References: <20130709082149.GK25631@dyad.programming.kicks-ass.net> <20130709093526.20138.93100.stgit@mhiramat-M0-7522>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709093526.20138.93100.stgit@mhiramat-M0-7522>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09, Masami Hiramatsu wrote:
>
> Wait for disabling all running kprobe handlers when a kprobe
> event is disabled, since the caller, trace_remove_event_call()
> supposes that a removing event is disabled completely by
> disabling the event.
> With this change, ftrace can ensure that there is no running
> event handlers after disabling it.
>
> Changes in V2:
>  - Comment (in code) for clarify why we need to wait there.
>
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Agreed.

We need this change in any case, whatever we do in trace/trace_events.c
and in unregister_trace_probe().

Oleg.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab3GIIU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 04:20:27 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:59229 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab3GIIUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 04:20:22 -0400
Message-ID: <51DBC7C1.9000601@hitachi.com>
Date: Tue, 09 Jul 2013 17:20:17 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>, jovi.zhangwei@huawei.com,
        Jiri Olsa <jolsa@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: Re: [RFC PATCH] tracing/kprobe: Wait for disabling all running
 kprobe handlers
References: <20130708142533.GA23749@redhat.com> <20130709080145.7975.83164.stgit@mhiramat-M0-7522> <20130709080744.GH25631@dyad.programming.kicks-ass.net>
In-Reply-To: <20130709080744.GH25631@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/09 17:07), Peter Zijlstra wrote:
> On Tue, Jul 09, 2013 at 05:01:45PM +0900, Masami Hiramatsu wrote:
>> +	if (wait) {
>> +		/*
>> +		 * synchronize with kprobe_trace_func/kretprobe_trace_func
>> +		 * to ensure disabled (all running handlers are finished)
>> +		 */
>> +		synchronize_sched();
>> +		kfree(link);	/* Ignored if link == NULL */
>> +	}
> 
> What's not clear to me from this comment is if we're only waiting for kfree()?
> In that case shouldn't we use call_rcu() to free the thing? Or do we need the
> sync_sched() for other purposes as well?

No, this is not only for kfree, but also to ensure completing
disabling process, because trace_remove_event_call() supposes
that for releasing event_call related objects (Those objects
will be accessed in the handlers).

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbaAHHu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 02:50:57 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50461 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbaAHHut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 02:50:49 -0500
X-AuditID: 9c930179-b7c89ae000006438-56-52cd03573faf
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [RFC][PATCH] tracing: Show available event triggers when no trigger is set
References: <20140107103548.0a84536d@gandalf.local.home>
Date: Wed, 08 Jan 2014 16:50:47 +0900
In-Reply-To: <20140107103548.0a84536d@gandalf.local.home> (Steven Rostedt's
	message of "Tue, 7 Jan 2014 10:35:48 -0500")
Message-ID: <87a9f6di94.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Tue, 7 Jan 2014 10:35:48 -0500, Steven Rostedt wrote:
> Currently there's no way to know what triggers exist on a kernel without
> looking at the source of the kernel or randomly trying out triggers.
> Instead of creating another file in the debugfs system, simply show
> what available triggers are there when cat'ing the trigger file when
> it has no events:
>
>  [root /sys/kernel/debug/tracing]# cat events/sched/sched_switch/trigger
>  # Available triggers:
>  # disable_event enable_event stacktrace snapshot traceoff traceon
>
> This stays consistent with other debugfs files where meta data like
> this is always proceeded with a '#' at the start of the line so that
> tools can strip these out.

[SNIP]
> +	if (v == SHOW_AVAILABLE_TRIGGERS) {
> +		seq_puts(m, "# Available triggers:\n");
> +		seq_putc(m, '#');
> +		mutex_lock(&trigger_cmd_mutex);
> +		list_for_each_entry(p, &trigger_commands, list)

I guess the list_for_each_entry_reverse() will give a more intuitive
result here:

  [root /sys/kernel/debug/tracing]# cat events/sched/sched_switch/trigger
  # Available triggers:
  # traceon traceoff snapshot stacktrace enable_event disable_event

Thanks,
Namhyung


> +			seq_printf(m, " %s", p->name);
> +		seq_putc(m, '\n');
> +		mutex_unlock(&trigger_cmd_mutex);
> +		return 0;
> +	}
>  
>  	data = list_entry(v, struct event_trigger_data, list);
>  	data->ops->print(m, data->ops, data);

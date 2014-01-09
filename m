Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbaAIWGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 17:06:54 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:61359 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751472AbaAIWGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 17:06:47 -0500
Date: Thu, 9 Jan 2014 17:06:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [RFC][PATCH] tracing: Show available event triggers when no
 trigger is set
Message-ID: <20140109170645.17c819ae@gandalf.local.home>
In-Reply-To: <87a9f6di94.fsf@sejong.aot.lge.com>
References: <20140107103548.0a84536d@gandalf.local.home>
	<87a9f6di94.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Jan 2014 16:50:47 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> [SNIP]
> > +	if (v == SHOW_AVAILABLE_TRIGGERS) {
> > +		seq_puts(m, "# Available triggers:\n");
> > +		seq_putc(m, '#');
> > +		mutex_lock(&trigger_cmd_mutex);
> > +		list_for_each_entry(p, &trigger_commands, list)
> 
> I guess the list_for_each_entry_reverse() will give a more intuitive
> result here:
> 
>   [root /sys/kernel/debug/tracing]# cat events/sched/sched_switch/trigger
>   # Available triggers:
>   # traceon traceoff snapshot stacktrace enable_event disable_event
> 

Updated. Thanks for the review.

-- Steve

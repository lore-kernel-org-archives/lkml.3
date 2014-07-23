Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294AbaGWTxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 15:53:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932620AbaGWTwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 15:52:38 -0400
Date: Wed, 23 Jul 2014 21:51:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: kill global_start_up
Message-ID: <20140723195100.GA30591@redhat.com>
References: <20140720151814.GA32439@redhat.com> <20140721094706.60eb3877@gandalf.local.home> <20140721095046.4343746d@gandalf.local.home> <20140723182911.GA19253@redhat.com> <20140723145319.78722824@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723145319.78722824@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23, Steven Rostedt wrote:
>
> On Wed, 23 Jul 2014 20:29:11 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Thanks for your report Steven, I updated my ~/people-i-hate file.
>
> Is that for me or Namhyung? Silly question, it has to be for Namhyung,
> as I'm sure I'm one of the first people already in that list.

Sure, you are already listed more than once.

> > probably even event_context_switch... I'll recheck and send the patch.

This one is used by probe_wakeup_sched_switch(), so we can't simply
remove it.

> > But what a user can do with other files? You obviously can't enable, say,
> > ftrace/bputs, if I understand correctly this is for trace_puts().
> >
>
> Yeah, as trace_printk() can turn into a trace_puts() we still want
> those to be read by trace-cmd. To do that, the formats for those files
> are exported.

Ah, indeed, thanks.

> See kernel/trace/trace_export.c and trace_entries.h

Yeeees, I already found them. And this wasn't easy ;)

Thanks,

Oleg.


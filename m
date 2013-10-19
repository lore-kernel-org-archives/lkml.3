Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab3JSMuH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 08:50:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab3JSMuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 08:50:06 -0400
Date: Sat, 19 Oct 2013 14:43:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Geyslan G. Bem" <geyslan@gmail.com>, kernel-br@googlegroups.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH] tracing: fix referencing after memory freeing and
	refactors code
Message-ID: <20131019124312.GA23872@redhat.com>
References: <1382060696-30746-1-git-send-email-geyslan@gmail.com> <20131017224605.2e1d4bab@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017224605.2e1d4bab@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17, Steven Rostedt wrote:
>
> On Thu, 17 Oct 2013 22:44:56 -0300
> "Geyslan G. Bem" <geyslan@gmail.com> wrote:
>
> > and fix the possible 'dir'
> > assignment after freeing it.

This should be safe afaics, nobody will use it anyway. Even
subsystem_release() won't be called if .open() fails. But I agree
this doesn't look good.

> I'm thinking of just nuking the tracing_open_generic() here. The only
> thing it does here is the tracing_disabled check. The assignment of
> inode->i_private to filp->private_data is pointless

The same for ftrace_enable_fops() and ftrace_event_filter_fops() at
least. The users of event_file_data() do not use ->private_data.

OTOH, say, trace_format_open() doesn't check tracing_disabled, so

> We could add a tracing_is_disabled() function to test instead.

perhaps it can have more callers.

Oleg.


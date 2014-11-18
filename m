Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaKRCoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 21:44:14 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:28740 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751499AbaKRCoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 21:44:13 -0500
Date: Mon, 17 Nov 2014 21:44:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [RFC][PATCH 11/23 v4] tracing: Do not use return values of
 trace_seq_printf() in syscall tracing
Message-ID: <20141117214411.73a12be4@gandalf.local.home>
In-Reply-To: <87ioids587.fsf@sejong.aot.lge.com>
References: <20141114011244.256115061@goodmis.org>
	<20141114011411.842421346@goodmis.org>
	<87ioids587.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014 09:49:12 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> On Thu, 13 Nov 2014 20:12:55 -0500, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> >
> > The functions trace_seq_printf() and friends will not be returning values
> > soon and will be void functions. To know if they succeeded or not, the
> > functions trace_seq_has_overflowed() and trace_handle_return() should be
> > used instead.
> >
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  kernel/trace/trace_syscalls.c | 43 +++++++++++++++----------------------------
> >  1 file changed, 15 insertions(+), 28 deletions(-)
> >
> > diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> > index 4dc8b79c5f75..2193e8038681 100644
> > --- a/kernel/trace/trace_syscalls.c
> > +++ b/kernel/trace/trace_syscalls.c
> > @@ -114,7 +114,7 @@ print_syscall_enter(struct trace_iterator *iter, int flags,
> >  	struct trace_entry *ent = iter->ent;
> >  	struct syscall_trace_enter *trace;
> >  	struct syscall_metadata *entry;
> > -	int i, ret, syscall;
> > +	int i, syscall;
> >  
> >  	trace = (typeof(trace))ent;
> >  	syscall = trace->nr;
> > @@ -128,35 +128,24 @@ print_syscall_enter(struct trace_iterator *iter, int flags,
> >  		goto end;
> >  	}
> >  
> > -	ret = trace_seq_printf(s, "%s(", entry->name);
> > -	if (!ret)
> > -		return TRACE_TYPE_PARTIAL_LINE;
> > +	trace_seq_printf(s, "%s(", entry->name);
> >  
> >  	for (i = 0; i < entry->nb_args; i++) {
> 
> 		if (trace_seq_has_overflowed())
> 			goto end;
> ?

Yeah, I guess I can do that.

Oh well, so much for not needing to post the first 13 patches again ;-)

-- Steve

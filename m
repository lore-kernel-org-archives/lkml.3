Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaB0WsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 17:48:18 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:35766 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaB0WsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 17:48:17 -0500
Date: Thu, 27 Feb 2014 14:48:14 -0800
From: josh@joshtriplett.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 25/46] kernel: Add prototype declaration to header file
 include/linux/ftrace.h
Message-ID: <20140227224814.GB30335@cloud>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
 <f43d408c30c2a4bd326995992f26f8e727b281d9.1393493277.git.rashika.kheria@gmail.com>
 <20140227143753.42451556@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140227143753.42451556@gandalf.local.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 02:37:53PM -0500, Steven Rostedt wrote:
> On Thu, 27 Feb 2014 17:32:47 +0530
> Rashika Kheria <rashika.kheria@gmail.com> wrote:
> 
> > Add prototype declaration of function to header file
> > include/linux/ftrace.h because it is used by more than one file.
> > 
> > This eliminates the following warning in kernel/trace/ftrace.c:
> > kernel/trace/ftrace.c:4914:5: warning: no previous prototype for ‘ftrace_graph_entry_stub’ [-Wmissing-prototypes]
> > 
> > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > ---
> >  include/linux/ftrace.h |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> > index 68ea184..da1c31f 100644
> > --- a/include/linux/ftrace.h
> > +++ b/include/linux/ftrace.h
> > @@ -672,6 +672,8 @@ struct ftrace_graph_ret {
> >  typedef void (*trace_func_graph_ret_t)(struct ftrace_graph_ret *); /* return */
> >  typedef int (*trace_func_graph_ent_t)(struct ftrace_graph_ent *); /* entry */
> >  
> > +int ftrace_graph_entry_stub(struct ftrace_graph_ent *trace);
> 
> This doesn't need to be in a header file as it is only called by
> assmebly. But I have no problems with it being in one, but it should
> have a comment stating this:
> 
> /* This is only called by assembly code, declared here for consistency */

That seems quite reasonable, yeah.

- Josh Triplett

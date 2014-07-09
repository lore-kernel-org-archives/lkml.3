Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbaGIODP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:03:15 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:28092 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755276AbaGIODO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:03:14 -0400
Date: Wed, 9 Jul 2014 10:03:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>
Subject: Re: [RFA][PATCH 06/27] microblaze: ftrace: Add call to
 ftrace_graph_is_dead() in function graph code
Message-ID: <20140709100310.3c3b25ff@gandalf.local.home>
In-Reply-To: <20140626165849.119568888@goodmis.org>
References: <20140626165221.736847419@goodmis.org>
	<20140626165849.119568888@goodmis.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal,

Can you ack this please?

-- Steve


On Thu, 26 Jun 2014 12:52:27 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> ftrace_stop() is going away as it disables parts of function tracing
> that affects users that should not be affected. But ftrace_graph_stop()
> is built on ftrace_stop(). Here's another example of killing all of
> function tracing because something went wrong with function graph
> tracing.
> 
> Instead of disabling all users of function tracing on function graph
> error, disable only function graph tracing. To do this, the arch code
> must call ftrace_graph_is_dead() before it implements function graph.
> 
> Cc: Michal Simek <monstr@monstr.eu>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/microblaze/kernel/ftrace.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/microblaze/kernel/ftrace.c b/arch/microblaze/kernel/ftrace.c
> index bbcd2533766c..fc7b48a52cd5 100644
> --- a/arch/microblaze/kernel/ftrace.c
> +++ b/arch/microblaze/kernel/ftrace.c
> @@ -27,6 +27,9 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
>  	unsigned long return_hooker = (unsigned long)
>  				&return_to_handler;
>  
> +	if (unlikely(ftrace_graph_is_dead()))
> +		return;
> +
>  	if (unlikely(atomic_read(&current->tracing_graph_pause)))
>  		return;
>  


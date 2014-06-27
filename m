Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaF0Ooo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:44:44 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:8530 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753173AbaF0Oon convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:44:43 -0400
Date: Fri, 27 Jun 2014 10:44:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr =?UTF-8?B?TWzDoWRlaw==?= <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [RFC][PATCH 3/5 v2] seq_buf: Move the seq_buf code to lib/
Message-ID: <20140627104441.0b441318@gandalf.local.home>
In-Reply-To: <20140627143956.GF23205@pathway.suse.cz>
References: <20140626214901.596791200@goodmis.org>
	<20140626220130.068245931@goodmis.org>
	<20140627134810.GC23205@pathway.suse.cz>
	<20140627102715.1b670022@gandalf.local.home>
	<20140627143956.GF23205@pathway.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014 16:39:56 +0200
Petr Mládek <pmladek@suse.cz> wrote:


> > Nope, it just was copied by mistake. It only added dead code, it didn't
> > move it.
> 
> It is really missing! You removed kernel/trace/seq_buf.c and you have to
> remove it also from kernel/trace/Makefile. :-)

OK, I see. Strange that this didn't complain when I compiled it :-/

Oh, I bet the .o file still existed. It would have complained if I did
a make clean first. But then it should have complained about the dual
definitions ??

-- Steve

> 
> Best Regards,
> Petr
> 
> > -- Steve
> > 
> > > 
> > > diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> > > index edc98c72a634..67d6369ddf83 100644
> > > --- a/kernel/trace/Makefile
> > > +++ b/kernel/trace/Makefile
> > > @@ -29,7 +29,6 @@ obj-$(CONFIG_RING_BUFFER_BENCHMARK) += ring_buffer_benchmark.o
> > >  obj-$(CONFIG_TRACING) += trace.o
> > >  obj-$(CONFIG_TRACING) += trace_output.o
> > >  obj-$(CONFIG_TRACING) += trace_seq.o
> > > -obj-$(CONFIG_TRACING) += seq_buf.o
> > >  obj-$(CONFIG_TRACING) += trace_stat.o
> > >  obj-$(CONFIG_TRACING) += trace_printk.o
> > >  obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
> > > 
> > > 
> > > Best Regards,
> > > Petr
> > 


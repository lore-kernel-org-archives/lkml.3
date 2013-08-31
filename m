Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab3HaUmZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 16:42:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7712 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab3HaUmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 16:42:24 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=9h7nfDi7qgwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Lovc2pkZwpIA:10 a=suQpZlP5M7fFKTF2m4oA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Subject: Re: [RFC][PATCH 12/18 v2] ftrace: Disable RCU unsafe checker when
 function graph is enabled
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
In-Reply-To: <20130831195550.GR3871@linux.vnet.ibm.com>
References: <20130831051117.884125230@goodmis.org>
	 <20130831051702.436132384@goodmis.org>
	 <20130831195550.GR3871@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Aug 2013 16:42:17 -0400
Message-ID: <1377981737.26624.6.camel@pippen.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-31 at 12:55 -0700, Paul E. McKenney wrote:
> On Sat, Aug 31, 2013 at 01:11:29AM -0400, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > Having the RCU unsafe checker running when function graph is enabled
> > can cause a live lock. That's because the RCU unsafe checker enables
> > full lockdep debugging on RCU which does a lot of interal calls that
> > may be traced by the function graph tacer. This adds quite a bit of
> 
> s/tacer/tracer/  (Yeah, yeah, picky, picky!)
> 
> > overhead and can possibly live lock the system.
> > 
> > Just do not do the RCU unsafe checks when function graph tracer is
> > enabled.
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> One question: How does the user/tester/developer know that RCU-unsafe
> checks have been disabled by function-graph tracing?  Would it make
> sense to print something to dmesg calling this out?  Or do the transitions
> happen too often?

Ideally, (for 3.13) I plan on having this be a sysctl switch. That will
be 1 or 0, depending on if it is enabled or not. But yeah, I can add a
printk to show that the kernel changed it. It doesn't happen often, and
mainly by a user (or selftest).

-- Steve

> 
> 							Thanx, Paul
> 
> > ---



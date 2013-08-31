Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab3HaUnc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 16:43:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3705 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab3HaUnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 16:43:31 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=evCvn7woWxUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=cXzqHbTEY4EA:10 a=VnNF1IyMAAAA:8 a=54jBMmSRJKeqt0ZiTtgA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Subject: Re: [RFC][PATCH 15/18 v2] ftrace/rcu: Mark functions that are RCU
 unsafe
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
In-Reply-To: <20130831200044.GU3871@linux.vnet.ibm.com>
References: <20130831051117.884125230@goodmis.org>
	 <20130831051702.922659300@goodmis.org>
	 <20130831200044.GU3871@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Aug 2013 16:43:24 -0400
Message-ID: <1377981804.26624.7.camel@pippen.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-31 at 13:00 -0700, Paul E. McKenney wrote:
> On Sat, Aug 31, 2013 at 01:11:32AM -0400, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > Some callbacks of the function tracer use rcu_read_lock(). This means that
> > there's places that can not be traced because RCU is not tracking the CPU
> > for various reasons (like NO_HZ_FULL and coming back from userspace).
> > 
> > Thes functions need to be marked so that callbacks that use RCU do not
> > trace them.
> > 
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Please let me know if you would like me to take this one.  If I don't
> hear otherwise, I will assume that you are pushing it.
> 

These I rather take, as they are all dependent on the previous changes.

Thanks!

-- Steve



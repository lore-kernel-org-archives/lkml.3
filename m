Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab3GKQza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:55:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32988 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab3GKQz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:55:27 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=mY5AGG0wUPsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=x45eBLDEq7QA:10 a=SlZC6DwobfxERQ2Y5Y4A:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373561726.17876.48.camel@gandalf.local.home>
Subject: Re: timer: lockup in run_timer_softirq()
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>,
        Tejun Heo <tj@kernel.org>, tglx@linutronix.de,
        LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org
Date: Thu, 11 Jul 2013 12:55:26 -0400
In-Reply-To: <20130711164204.GK25631@dyad.programming.kicks-ass.net>
References: <51DC902F.3070403@oracle.com>
	 <20130709224706.GA13855@redhat.com> <51DC9379.9050408@oracle.com>
	 <20130709230316.GB13855@redhat.com> <51DC983F.2010409@oracle.com>
	 <20130710095210.GD17211@twins.programming.kicks-ass.net>
	 <1373459254.7458.49.camel@gandalf.local.home>
	 <20130710124245.GT25631@dyad.programming.kicks-ass.net>
	 <1373461091.7458.55.camel@gandalf.local.home>
	 <20130711164204.GK25631@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 18:42 +0200, Peter Zijlstra wrote:

> I'm afraid this is going to be hard to create and hard to keep correct :/

That's the nature of tracing functions ;-)

> 
> Other than that, a function tracer environment that is safer to use might be
> useful for other people as well.

Not sure how to make the environment safe, as the main purpose of the
function trace is to debug those hard to debug locations, like NMIs,
RCU, dynamic ticks, etc. To ensure a "safe" environment, it would
cripple the tracer.

Hmm, what would you state as a safe environment? How can we detect if
the environment is safe to trace or not?

-- Steve



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab3HERYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:24:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28985 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab3HERYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:24:13 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pFOAptgLnqcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pvQ05lsfB1wA:10 a=Qi55U2n7E8-jIZQsX3QA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375723451.22073.85.camel@gandalf.local.home>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Mon, 05 Aug 2013 13:24:11 -0400
In-Reply-To: <51FFDAA0.6020107@linux.intel.com>
References: <1375721715.22073.80.camel@gandalf.local.home>
	 <51FFDAA0.6020107@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-05 at 10:02 -0700, H. Peter Anvin wrote:

> > if (x) __attibute__((section(".foo"))) {
> > 	/* do something */
> > }
> > 
> 
> One concern I have is how this kind of code would work when embedded
> inside a function which already has a section attribute.  This could
> easily cause really weird bugs when someone "optimizes" an inline or
> macro and breaks a single call site...

I would say that it overrides the section it is embedded in. Basically
like a .pushsection and .popsection would work.

What bugs do you think would happen? Sure, this used in an .init section
would have this code sit around after boot up. I'm sure modules could
handle this properly. What other uses of attribute section is there for
code? I'm aware of locks and sched using it but that's more for
debugging purposes and even there, the worse thing I see is that a debug
report wont say that the code is in the section.

We do a lot of tricks with sections in the Linux kernel, so I too share
your concern. But even with that, if we audit all use cases, we may
still be able to safely do this. This is why I'm asking for comments :-)

-- Steve



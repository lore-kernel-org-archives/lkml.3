Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbaCED1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:27:18 -0500
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:40967 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753797AbaCED1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:27:17 -0500
Date: Tue, 4 Mar 2014 21:27:14 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Andrew Morton <akpm@linux-foundation.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 05/48] percpu: Add preemption checks to __this_cpu ops
In-Reply-To: <20140304142727.3e6d260c752c2e2ebd49260e@linux-foundation.org>
Message-ID: <alpine.DEB.2.10.1403042125060.3742@nuc>
References: <20140214201841.826179349@linux.com> <20140214201904.443470635@linux.com> <20140304142727.3e6d260c752c2e2ebd49260e@linux-foundation.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2014, Andrew Morton wrote:

> >  	print_symbol("caller is %s\n", (long)__builtin_return_address(0));
> >  	dump_stack();
>
> I wonder if there's any point in printing __builtin_return_address.
> Doesn't dump_stack() tell us the same thing?

Yes it does. However, it was there before and software may scan the logs
for it.

> > +notrace void __this_cpu_preempt_check(const char *op)
> > +{
> > +	char text[40];
> > +
> > +	snprintf(text, sizeof(text), "__this_cpu_%s()", op);
> > +	check_preemption_disabled(text);
> > +}
>
> I'd like to see a comment here telling scared readers why this can
> never overflow text[].

Ok. I can also add VM_BUG_ON(strlen(op) >= sizeof(text)) ?


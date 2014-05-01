Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaEAURu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 16:17:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41239 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbaEAURt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 16:17:49 -0400
Date: Thu, 1 May 2014 22:17:44 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC 09/16] kgr: mark task_safe in some kthreads
In-Reply-To: <20140501142414.GA31611@htj.dyndns.org>
Message-ID: <alpine.LNX.2.00.1405012206430.29834@pobox.suse.cz>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz> <1398868249-26169-10-git-send-email-jslaby@suse.cz> <20140501142414.GA31611@htj.dyndns.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2014, Tejun Heo wrote:

> > Some threads do not use kthread_should_stop. Before we enable a
> 
> Haven't really following kgraft development but is it safe to assume
> that all kthread_should_stop() usages are clean side-effect-less
> boundaries?  If so, why is that property guaranteed?  Is there any
> mechanism for sanity checks?  Maybe I'm just failing to understand how
> the whole thing is supposed to work but this looks like it could
> devolve into something more broken than the freezer which we haven't
> fully recovered from yet.

Hi Tejun,

first, thanks a lot for review.

I agree that this expectation might really somewhat implicit and is not 
probably properly documented anywhere. The basic observation is "whenever 
kthread_should_stop() is being called, all data structures are in a 
consistent state and don't need any further updates in order to achieve 
consistency, because we can exit the loop immediately here", as 
kthread_should_stop() is the very last thing every freezable kernel thread 
is calling before starting a new iteration.

For the sake of collecting data points -- do you happen to have any 
counter-example to the assumption?

Thanks,

-- 
Jiri Kosina
SUSE Labs

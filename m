Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaHHSoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 14:44:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:44234 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751041AbaHHSoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 14:44:15 -0400
Date: Fri, 8 Aug 2014 14:44:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [RFC][PATCH 0/5 v2] x86/nmi: Print all cpu stacks from NMI
 safely
Message-ID: <20140808144412.1357dd05@gandalf.local.home>
In-Reply-To: <alpine.LNX.2.00.1408071034450.6219@pobox.suse.cz>
References: <20140626214901.596791200@goodmis.org>
	<alpine.LNX.2.00.1408071034450.6219@pobox.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2014 10:41:45 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Thu, 26 Jun 2014, Steven Rostedt wrote:
> 
> > This is version 2:
> > 
> > This is my proposal to print the NMI stack traces from an RCU stall safely.
> > Here's the gist of it.
> 
> Steven, what's your plan with this patchset please? 

Has there been consensus on this approach?

> 
> It has been tested by Petr here on the systems under the loads that are 
> able to trigger the hangs.
> 
> It'd be nice to have this in 3.17, so that we can then start working on 
> fixing all the remaining printk() calls in NMI context once this biggest 
> offender (stack dumping) is done.

It definitely wont be in 3.17 (too late). I'm fine with getting this
ready unless there's other objections.

3.17 does contain the updates to trace_seq that Andrew made. Linus had
issues with the "trace" name, which this patch set creates a new
"seq_buf" that is a subset of the trace_seq.

I'll keep this on my todo list for 3.18 and push out patches to get
people's comments about it after 3.17 merge window has closed (the
required people are a bit busy at the moment).

-- Steve

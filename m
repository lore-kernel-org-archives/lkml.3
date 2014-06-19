Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965879AbaFSXDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 19:03:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964958AbaFSXDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 19:03:32 -0400
Date: Fri, 20 Jun 2014 01:03:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [RFC][PATCH 0/3] x86/nmi: Print all cpu stacks from NMI safely
In-Reply-To: <20140619185810.4137e14b@gandalf.local.home>
Message-ID: <alpine.LNX.2.00.1406200100520.15014@pobox.suse.cz>
References: <20140619213329.478113470@goodmis.org> <alpine.LNX.2.00.1406192349400.15014@pobox.suse.cz> <20140619185810.4137e14b@gandalf.local.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Steven Rostedt wrote:

> > The idea basically is to *switch* what arch_trigger_all_cpu_backtrace() 
> > and arch_trigger_all_cpu_backtrace_handler() are doing; i.e. use the NMI 
> > as a way to stop all the CPUs (one by one), and let the CPU that is 
> > sending the NMIs around to actually walk and dump the stacks of the CPUs 
> > receiving the NMI IPI.
> 
> And this is cleaner? Stopping a CPU via NMI and then what happens if
> something else goes wrong and that CPU never starts back up? This
> sounds like something that can cause more problems than it was
> reporting on.

It's going to get NMI in exactly the same situations it does with the 
current arch_trigger_all_cpu_backtrace(), the only difference being that 
it doesn't try to invoke printk() from inside NMI. The IPI-NMI is used 
solely as a point of synchronization for the stack dumping.

> Then you also need to print out the data while the NMIs still spin.

Exactly, that's actually the whole point.

Thanks,

-- 
Jiri Kosina
SUSE Labs

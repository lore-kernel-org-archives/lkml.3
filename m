Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965985AbaFSXT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 19:19:29 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:36268 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965467AbaFSXT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 19:19:28 -0400
Date: Thu, 19 Jun 2014 19:19:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [RFC][PATCH 0/3] x86/nmi: Print all cpu stacks from NMI safely
Message-ID: <20140619191923.1365850a@gandalf.local.home>
In-Reply-To: <alpine.LNX.2.00.1406200100520.15014@pobox.suse.cz>
References: <20140619213329.478113470@goodmis.org>
	<alpine.LNX.2.00.1406192349400.15014@pobox.suse.cz>
	<20140619185810.4137e14b@gandalf.local.home>
	<alpine.LNX.2.00.1406200100520.15014@pobox.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014 01:03:28 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Thu, 19 Jun 2014, Steven Rostedt wrote:
> 
> > > The idea basically is to *switch* what arch_trigger_all_cpu_backtrace() 
> > > and arch_trigger_all_cpu_backtrace_handler() are doing; i.e. use the NMI 
> > > as a way to stop all the CPUs (one by one), and let the CPU that is 
> > > sending the NMIs around to actually walk and dump the stacks of the CPUs 
> > > receiving the NMI IPI.
> > 
> > And this is cleaner? Stopping a CPU via NMI and then what happens if
> > something else goes wrong and that CPU never starts back up? This
> > sounds like something that can cause more problems than it was
> > reporting on.
> 
> It's going to get NMI in exactly the same situations it does with the 
> current arch_trigger_all_cpu_backtrace(), the only difference being that 
> it doesn't try to invoke printk() from inside NMI. The IPI-NMI is used 
> solely as a point of synchronization for the stack dumping.

Well, all CPUs are going to be spinning until the main CPU prints
everything out. That's not quite the same thing as what it use to do.

> 
> > Then you also need to print out the data while the NMIs still spin.
> 
> Exactly, that's actually the whole point.

But this stops everything with a big hammer, until everything gets
printed out, not just the one CPU that happens to be stuck.

-- Steve


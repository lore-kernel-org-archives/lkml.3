Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaAWLwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 06:52:09 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:37621 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750869AbaAWLwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 06:52:07 -0500
Date: Thu, 23 Jan 2014 06:52:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
Subject: Re: [PATCH] tracing: Use task_nice() in function __update_max_tr()
 to get the nice value of task.
Message-ID: <20140123065204.4e0b6902@gandalf.local.home>
In-Reply-To: <20140123082630.GO30183@twins.programming.kicks-ass.net>
References: <1390430505-17234-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<20140122225632.73c2fbdf@gandalf.local.home>
	<20140122230029.638e9a53@gandalf.local.home>
	<52E14D28.2090208@cn.fujitsu.com>
	<20140123082630.GO30183@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014 09:26:30 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Jan 23, 2014 at 12:11:04PM -0500, Dongsheng Yang wrote:
> > On 01/22/2014 11:00 PM, Steven Rostedt wrote:
> > >
> > >Bah, I just noticed that TASK_NICE is in kernel/sched/sched.h not
> > >include/linux/sched.h
> > >
> > >Peter, is there a reason that task_nice() is not a static inline in
> > >sched.h and have these macros there too? They only reference fields in
> > >task_struct that are already defined there. I don't see why they need
> > >to be private to kernel/sched.
> > 
> > Agree. These macros are useful to other modules out of kernel/sched.
> > But they are private to kernel/sched currently.
> 
> And the floodgates open.. _why_ would a module care about nice values?
> That's sounds just so full of wrong.

As Dongsheng already said, it's not for modules, but for other parts of
the core kernel.

It's not like modules or other parts can't just reimplement those
macros. All the fields are already public in linux/sched.h. In fact, the
reason for this discussion is to get rid of an open coded implementation
in the tracing facility.

-- Steve

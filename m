Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbaAWI06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 03:26:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54145 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbaAWI05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 03:26:57 -0500
Date: Thu, 23 Jan 2014 09:26:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
Subject: Re: [PATCH] tracing: Use task_nice() in function __update_max_tr()
 to get the nice value of task.
Message-ID: <20140123082630.GO30183@twins.programming.kicks-ass.net>
References: <1390430505-17234-1-git-send-email-yangds.fnst@cn.fujitsu.com>
 <20140122225632.73c2fbdf@gandalf.local.home>
 <20140122230029.638e9a53@gandalf.local.home>
 <52E14D28.2090208@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E14D28.2090208@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 12:11:04PM -0500, Dongsheng Yang wrote:
> On 01/22/2014 11:00 PM, Steven Rostedt wrote:
> >
> >Bah, I just noticed that TASK_NICE is in kernel/sched/sched.h not
> >include/linux/sched.h
> >
> >Peter, is there a reason that task_nice() is not a static inline in
> >sched.h and have these macros there too? They only reference fields in
> >task_struct that are already defined there. I don't see why they need
> >to be private to kernel/sched.
> 
> Agree. These macros are useful to other modules out of kernel/sched.
> But they are private to kernel/sched currently.

And the floodgates open.. _why_ would a module care about nice values?
That's sounds just so full of wrong.


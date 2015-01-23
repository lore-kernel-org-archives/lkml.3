Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbbAWEu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 23:50:29 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:20866 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753460AbbAWEuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 23:50:22 -0500
Date: Thu, 22 Jan 2015 23:50:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Suruchi Kadu <suruchi.a.kadu@intel.com>,
        Doug Nelson <doug.nelson@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched-rt: Reduce excessive task push rate by not
 pushing tasks with equal priority as the current task
Message-ID: <20150122235048.5246a611@grimm.local.home>
In-Reply-To: <1421987370.5280.21.camel@marge.simpson.net>
References: <1421952836.2399.58.camel@schen9-desk2.jf.intel.com>
	<1421987370.5280.21.camel@marge.simpson.net>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015 05:29:30 +0100
Mike Galbraith <umgwanakikbuti@gmail.com> wrote:

> On Thu, 2015-01-22 at 10:53 -0800, Tim Chen wrote: 
> > Commit 3be209a8 tries to migrate task of equal priority as the
> > running one to other cpus to balance load and eliminate any idle
> > cpus.  However, for system that is fully busy and running workload
> > of a few priorities, we found this change to cause tasks getting
> > pushed around without improving cpu utilization. On a fully loaded
> > system running a well known OLTP benchmark, it causes 70% more run
> > queue locking in the push task path without improving cpu
> > utilization and make throughput degrade by 1.5%. We observe much
> > higher rq lock contention due to excessive lockings of target run
> > queues on task wakeup.
> 
> Pushing tasks of equal priority is about getting rt tasks to a CPU
> they can utilize NOW.  Trying to improve throughput and whatnot is
> all well and good, but sacrificing the most sacred rt cow on the
> planet to improve some benchmark number is a very bad idea :)
> 

What Mike said.

With RT tasks the #1 importance is running as soon as they should run.
Throughput is #2. We never sacrifice #1 to improve #2.

Non RT tasks have much better throughput algorithms than RT tasks. But
they are much less likely to react to an event consistently as an RT
task will.

Never give a task an RT priority if your main objective is to have it
"run faster". If you do, you have no clue about what RT is used for.

-- Steve

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbbAWE3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 23:29:36 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:64619 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbbAWE3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 23:29:34 -0500
Message-ID: <1421987370.5280.21.camel@marge.simpson.net>
Subject: Re: [PATCH] sched-rt: Reduce excessive task push rate by not
 pushing tasks with equal priority as the current task
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Suruchi Kadu <suruchi.a.kadu@intel.com>,
        Doug Nelson <doug.nelson@intel.com>, linux-kernel@vger.kernel.org
Date: Fri, 23 Jan 2015 05:29:30 +0100
In-Reply-To: <1421952836.2399.58.camel@schen9-desk2.jf.intel.com>
References: <1421952836.2399.58.camel@schen9-desk2.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-22 at 10:53 -0800, Tim Chen wrote: 
> Commit 3be209a8 tries to migrate task of equal priority as the running
> one to other cpus to balance load and eliminate any idle cpus.  However,
> for system that is fully busy and running workload of a few priorities,
> we found this change to cause tasks getting pushed around without
> improving cpu utilization. On a fully loaded system running a well known
> OLTP benchmark, it causes 70% more run queue locking in the push task
> path without improving cpu utilization and make throughput degrade by
> 1.5%. We observe much higher rq lock contention due to excessive lockings
> of target run queues on task wakeup.

Pushing tasks of equal priority is about getting rt tasks to a CPU they
can utilize NOW.  Trying to improve throughput and whatnot is all well
and good, but sacrificing the most sacred rt cow on the planet to
improve some benchmark number is a very bad idea :)

-Mike


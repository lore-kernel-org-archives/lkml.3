Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaAXLck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 06:32:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32851 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaAXLci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 06:32:38 -0500
Date: Fri, 24 Jan 2014 12:32:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Dan Ballard <dan@mindstab.net>, kay.sievers@vrfy.org,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minto Joseph <mvaliyav@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Rik van Riel <riel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Mel Gorman <mgorman@suse.de>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] add StartTimeMonotomic, StartTimeBootTime to per pid
  in   /proc
Message-ID: <20140124113203.GZ30183@twins.programming.kicks-ass.net>
References: <a24256fcec0f1735512ee303ce8abbdc@mindstab.net>
 <20140122155351.GV13532@twins.programming.kicks-ass.net>
 <20140124102037.GE4870@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140124102037.GE4870@tango.0pointer.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 11:20:38AM +0100, Lennart Poettering wrote:
> On Wed, 22.01.14 16:53, Peter Zijlstra (peterz@infradead.org) wrote:
> 
> > 
> > On Tue, Jan 21, 2014 at 07:10:04AM -0800, Dan Ballard wrote:
> > > starttime in /proc/$PID/stat is inaccurate by "clock tick" granularity.
> > > The kernel keeps better track os this exposes that in /prod/$PID/status
> > > as StartTimeMonotonic and StartTimeBootTime
> > 
> > Why?
> 
> Well, the canonical way to expose clocks to userspace these days is with
> CLOCK_MONOTONIC, CLOCK_BOOTTIME, and so on. The starttime is currently
> exposed in a way that is made inaccurate by the clock tick in
> /proc/$PID/stat. Dan's patch simply unfucks that interface.

That's actually factually incorrect. The start_time in task_stat is the
exact same as used by Dan, its just that task_stat() decides to wreck it
before printing it. Doesn't have anything to do with the actual clock
tick.

> The process starttime is useful for a variety of things, like figuring
> out creation ordering of processes. Or it is useful to detect PID
> reuses in a somewhat reliable way. 

OK, maybe. Changelog should have said so.

> It is useful information to show the admin in "ps".

Does the one jiffy rounding really matter there? I doubt it, ps
typically shows in second granularity.

> Profilers like "bootchart" can use this information to
> plot when precisely specific process got started. From the outside it is
> often useful to see for how long a specific process has already been
> running, for accounting needs, and so on.

Profilers have far better interfaces than /proc to get information from.

> Note that Dan's patch doesn't add any new timestamp logic to the kernel,
> it just exposes the existing timestamps in a way to userspace that is
> more in line with the rest of timestamps exposed. 

Yeah, Dan was also too lazy to explain the need, and had like 3 typoes
in the inadequate changelog he had.

He also fails to explain why he needs the timestamp twice, as do you for
that matter.

Does not inspire confidence.

Now please all untwist your panties and try and submit a proper patch.

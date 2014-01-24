Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaAXMtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:49:43 -0500
Received: from tango.0pointer.de ([85.214.72.216]:48055 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbaAXMtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:49:41 -0500
Date: Fri, 24 Jan 2014 13:49:39 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Peter Zijlstra <peterz@infradead.org>
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
Subject: Re: [PATCH 1/1] add StartTimeMonotomic, StartTimeBootTime to per
 pid   in   /proc
Message-ID: <20140124124939.GA6146@tango.0pointer.de>
References: <a24256fcec0f1735512ee303ce8abbdc@mindstab.net>
 <20140122155351.GV13532@twins.programming.kicks-ass.net>
 <20140124102037.GE4870@tango.0pointer.de>
 <20140124113203.GZ30183@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140124113203.GZ30183@twins.programming.kicks-ass.net>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24.01.14 12:32, Peter Zijlstra (peterz@infradead.org) wrote:

> > The process starttime is useful for a variety of things, like figuring
> > out creation ordering of processes. Or it is useful to detect PID
> > reuses in a somewhat reliable way. 
> 
> OK, maybe. Changelog should have said so.
> 
> > It is useful information to show the admin in "ps".
> 
> Does the one jiffy rounding really matter there? I doubt it, ps
> typically shows in second granularity.

Well, it's just annoying. Much of userspace uses CLOCK_MONOTONIC
throughout all the local timestamping needs these days, however the jiffy rounding
and the fact that "starttime" is based on CLOCK_BOOTTIME makes it hard
to compare process timestamps currently with other timestamps...

> > Profilers like "bootchart" can use this information to
> > plot when precisely specific process got started. From the outside it is
> > often useful to see for how long a specific process has already been
> > running, for accounting needs, and so on.
> 
> Profilers have far better interfaces than /proc to get information
> from.

That is true, but note that at least on Fedora taskstats and thing are
actually disabled these days in the kernel, since they slow things down
too much. The /proc interface is certainly much nicer there, since it
relies on a the timestamping the kernel does anyway...

> > Note that Dan's patch doesn't add any new timestamp logic to the kernel,
> > it just exposes the existing timestamps in a way to userspace that is
> > more in line with the rest of timestamps exposed. 
> 
> Yeah, Dan was also too lazy to explain the need, and had like 3 typoes
> in the inadequate changelog he had.
> 
> He also fails to explain why he needs the timestamp twice, as do you for
> that matter.

Well, I am mostly interesting int the monotonic timestamp. But given
that the kernel keeps the boottime clock value as well, and already
exposes it in a skewed way to userspace it looked like a natural choice
to also expose that time in a clean way, while we are it...

Lennart

-- 
Lennart Poettering, Red Hat

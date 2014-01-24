Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaAXK2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 05:28:20 -0500
Received: from tango.0pointer.de ([85.214.72.216]:46976 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaAXK2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 05:28:16 -0500
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jan 2014 05:28:16 EST
Date: Fri, 24 Jan 2014 11:20:38 +0100
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
 pid  in   /proc
Message-ID: <20140124102037.GE4870@tango.0pointer.de>
References: <a24256fcec0f1735512ee303ce8abbdc@mindstab.net>
 <20140122155351.GV13532@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122155351.GV13532@twins.programming.kicks-ass.net>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22.01.14 16:53, Peter Zijlstra (peterz@infradead.org) wrote:

> 
> On Tue, Jan 21, 2014 at 07:10:04AM -0800, Dan Ballard wrote:
> > starttime in /proc/$PID/stat is inaccurate by "clock tick" granularity.
> > The kernel keeps better track os this exposes that in /prod/$PID/status
> > as StartTimeMonotonic and StartTimeBootTime
> 
> Why?

Well, the canonical way to expose clocks to userspace these days is with
CLOCK_MONOTONIC, CLOCK_BOOTTIME, and so on. The starttime is currently
exposed in a way that is made inaccurate by the clock tick in
/proc/$PID/stat. Dan's patch simply unfucks that interface.

The process starttime is useful for a variety of things, like figuring
out creation ordering of processes. Or it is useful to detect PID
reuses in a somewhat reliable way. It is useful information to show the
admin in "ps". Profilers like "bootchart" can use this information to
plot when precisely specific process got started. From the outside it is
often useful to see for how long a specific process has already been
running, for accounting needs, and so on.

Note that Dan's patch doesn't add any new timestamp logic to the kernel,
it just exposes the existing timestamps in a way to userspace that is
more in line with the rest of timestamps exposed. 

Lennart

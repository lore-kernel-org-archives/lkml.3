Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaKYDDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 22:03:48 -0500
Received: from g4t3426.houston.hp.com ([15.201.208.54]:57301 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaKYDDr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 22:03:47 -0500
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Mitchel Humpherys <mitchelh@codeaurora.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Wagantall <mattw@codeaurora.org>,
        "Don Brace (PMC)" <Don.Brace@pmcs.com>,
        "Scales, Webb" <webb.scales@hp.com>
Subject: RE: [PATCH RESEND v8] iopoll: Introduce memory-mapped IO polling
 macros
Thread-Topic: [PATCH RESEND v8] iopoll: Introduce memory-mapped IO polling
 macros
Thread-Index: AQHQCE4XAqVL7P1v/0SqGz4Bzc5Be5xwoQew
Date: Tue, 25 Nov 2014 03:02:30 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593C61A3@G9W0745.americas.hpqcorp.net>
References: <1416860092-11620-1-git-send-email-mitchelh@codeaurora.org>
	<94D0CD8314A33A4D9D801C0FE68B4029593C5E1F@G9W0745.americas.hpqcorp.net>
 <vnkwy4r0gjne.fsf@mitchelh-linux.qualcomm.com>
In-Reply-To: <vnkwy4r0gjne.fsf@mitchelh-linux.qualcomm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.216.65.177]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Mitchel Humpherys [mailto:mitchelh@codeaurora.org]
> Sent: Monday, November 24, 2014 7:21 PM
> To: Elliott, Robert (Server Storage)
...
> > The hpsa SCSI driver used to use usleep_range in a loop like
> > that, but we found that it caused scheduler problems during
> > boots because it uses TASK_UNINTERRUPTIBLE:
> > [    9.260668] [sched_delayed] sched: RT throttling activated
> >
> > msleep() worked much better.

Sorry, that might have been msleep_interruptible() - the fixes
are still not upstream, so I'll have to doublecheck tomorrow.

> Hmm, maybe you were just sleeping for too long?  According to
> Documentation/timers/timers-howto.txt, usleep_range is what should be
> used for non-atomic sleeps in the range [10us, 20ms].  Plus we need
> microsecond granularity anyways, so msleep wouldn't cut it.

The intervals and the overall number of loops were indeed long.  I 
think the corrected code waits a total of 1 second; before the fix,
600 seconds.

> If there are any potential users of these macros that would want to
> sleep for more than 20ms I guess we could add a special case here to use
> msleep when sleep_us exceeds 20,000 or so.
...

Maybe just a comment in the documentation for the macro would suffice,
possibly with a separate macro for longer interval sleeps.  I don't
want to force an extra msleep() call to be compiled into a bunch
of places where it's not needed.


---
Rob Elliott    HP Server Storage



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbaFDAdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 20:33:44 -0400
Received: from smtprelay0002.hostedemail.com ([216.40.44.2]:39858 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752100AbaFDAdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 20:33:43 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 40,2.5,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:171
X-HE-Tag: sky06_2d1392de5c1d
X-Filterd-Recvd-Size: 3673
Message-ID: <1401842017.22133.30.camel@joe-AO725>
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
From: Joe Perches <joe@perches.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: josh@joshtriplett.org, Dave Chinner <david@fromorbit.com>,
        Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        sbw@mit.edu
Date: Tue, 03 Jun 2014 17:33:37 -0700
In-Reply-To: <20140603234816.GB26144@milliways>
References: <20140602181658.GX22231@linux.vnet.ibm.com>
	 <1401734669.7323.20.camel@joe-AO725>
	 <20140602145020.400d4e0c@gandalf.local.home> <20140602185504.GA13569@cloud>
	 <1401735917.7323.23.camel@joe-AO725> <20140602190951.GA13648@cloud>
	 <1401736666.7323.25.camel@joe-AO725> <20140602231949.GV14410@dastard>
	 <20140602235915.GB14801@cloud> <1401754325.7323.50.camel@joe-AO725>
	 <20140603234816.GB26144@milliways>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-04 at 00:48 +0100, Ken Moffat wrote:
> On Mon, Jun 02, 2014 at 05:12:05PM -0700, Joe Perches wrote:
> > "Tested-by:" tags would be more helpful if the test
> > cases that were used were somehow sent along with the
> > signature.
[]
> Tested-by is usually used for a fix of some problem, often a
> regression.  A good commit message will explain the problem.

It seems about half of the commits with tested-by are
for regressions.

The latest commit message with your tested-by is great.

commit 18ee37a485653aa635cfab9a3710e9bcf5fbca01
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri May 30 16:41:23 2014 +0200

    drm/radeon: Resume fbcon last
 
[detailed explanation elided]

This commit log with your tested-by seems a bit
mysterious though:

commit 74ad54f249de39bc040cce7237b1b854a9c6f0ad
Author: Christian König <christian.koenig@amd.com>
Date:   Tue May 13 12:50:54 2014 +0200

    drm/radeon: fix typo in finding PLL params
    
    Otherwise the limit is raised to high.

As the commit that introduces this error is:

commit 3b333c55485fef0089ae7398906599d000df195e
Author: Christian König <christian.koenig@amd.com>
Date:   Thu Apr 24 18:39:59 2014 +0200

    drm/radeon: avoid high jitter with small frac divs

This is the entirety of the commit log.

The calculation that was done here:

	max(fb_div_min, (9 - (fb_div % 10)) * 20 + 60)

Doesn't give any indication why 50 is better than 60.

> This is _often_ not like userspace programs where you can write a
> testsuite to exercise the corner cases.  Kernel problems can be
> tied up with intricate details of the hardware, or equally they
> might happen only for certain usage, and for those it might not be
> at all obvious what is "special" about the affected usage.

Shrug.  Mostly where that wonderful test robot that
Fengguang Wu put together can aid in finding regressions,
it'd be nice if the tested-by: tests done could be added
somehow.  And not in the commit log itself.

It's certainly not possible for test cases to be mandatory.

cheers, Joe


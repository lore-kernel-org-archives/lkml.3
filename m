Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaBPTnd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 14:43:33 -0500
Received: from one.firstfloor.org ([193.170.194.197]:48003 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbaBPTnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 14:43:32 -0500
Date: Sun, 16 Feb 2014 20:43:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@kernel.org, eranian@google.com,
        linux-kernel@vger.kernel.org,
        Markus Metzger <markus.t.metzger@intel.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, nmi: fix unknown NMI warning
Message-ID: <20140216194330.GE32005@two.firstfloor.org>
References: <1392425048-5309-1-git-send-email-andi@firstfloor.org>
 <20140215095843.GJ14089@laptop.programming.kicks-ass.net>
 <20140216183850.GD32005@two.firstfloor.org>
 <20140216192312.GM14089@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140216192312.GM14089@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The best APIC documentation are the old data sheets for the external
APIC chips. I don't know if they cover things in such detail.

> In this case the latter NMI will actually have an overflow state to
> process so it's not a spurious NMI.

But we cannot distinguish it right? The spurious detector would
trigger in any case.

> 
> > And if we're in a state that PMIs get re-raised quickly, we should either
> > regulate the period down or start throttling.
> 
> It could be a different counter; where both run at 'normal' periods but
> just near miss each other by accident.

That's true.

It would be only a problem if they somehow become synchronized that
this happens very commonly. The usual defense against things like 
that is to add a little randomization (I remember Stephane had
a patch for that some time ago). Also I believe it helps to have
the periods be prime numbers. But right now don't have any evidence
it's a real problem. I presume there's enough noise on a typical
setup that any such states disappear again quickly enough.

-Andi

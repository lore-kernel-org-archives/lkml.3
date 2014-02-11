Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaBKRsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:48:37 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57794 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909AbaBKRsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:48:35 -0500
Date: Tue, 11 Feb 2014 17:48:05 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Dave P Martin <Dave.Martin@arm.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 4/7] perf: be less pessimistic when scheduling events
Message-ID: <20140211174804.GC12476@e106331-lin.cambridge.arm.com>
References: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
 <1392054264-23570-5-git-send-email-mark.rutland@arm.com>
 <20140210175854.GB27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210175854.GB27965@twins.programming.kicks-ass.net>
Thread-Topic: [PATCH 4/7] perf: be less pessimistic when scheduling events
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 05:58:54PM +0000, Peter Zijlstra wrote:
> On Mon, Feb 10, 2014 at 05:44:21PM +0000, Mark Rutland wrote:
> > This patch makes ctx_flexible_sched_in attempt to schedule every group
> > in the flexible_groups list even when earlier groups failed to schedule,
> > enabling more groups to be scheduled simultaneously.
> 
> Since you're basically free to create as many events as you want, you can
> (as an unprivilidged user) make the context switch to and from your task
> arbitrarily expensive.

Not that it makes the approach any better, but surely this is already
the case for software events? I can create as many as I want, and
they'll always try to schedule.

I'll take a look into other ways to stop disparate PMUs' events from
adversely affecting each other. I guess it might not be possible to
solve the general problem without allowing said expensive context
switch.

Thanks,
Mark.

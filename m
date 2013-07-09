Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab3GIOco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:32:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57029 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab3GIOcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:32:43 -0400
Date: Tue, 9 Jul 2013 16:31:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com
Subject: Re: [PATCH] perf: Update event buffer tail when overwriting old
 events
Message-ID: <20130709143150.GL25631@dyad.programming.kicks-ass.net>
References: <1370498286-12801-1-git-send-email-zheng.z.yan@intel.com>
 <20130708121557.GA17211@twins.programming.kicks-ass.net>
 <51DBB645.5070201@intel.com>
 <20130709080513.GG25631@dyad.programming.kicks-ass.net>
 <51DC1591.7070907@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DC1591.7070907@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 09:52:17PM +0800, Yan, Zheng wrote:
> On 07/09/2013 04:05 PM, Peter Zijlstra wrote:
> > On Tue, Jul 09, 2013 at 03:05:41PM +0800, Yan, Zheng wrote:
> > 
> >> Thank you for your help. I ran the same test, the results for regular case
> >> are much better. But it still has about 1% overhead, probably because we
> >> enlarge the ring_buffer structure, make it less cache friendly.
> >>
> >>       origin    with the patch
> >> AVG    1000      1013
> >> STDEV  13.4      15.0
> > 
> > And this is the !overwrite case, right? I don't suppose you cured the logic
> > Namhyung Kim pointed out? That should affect the overwrite case I suppose since
> > it won't switch to perf_event_output_overwrite().
> 
> yes, it's the overwrite case.

So the most common case is the !overwrite one; we should ensure no significant
regression there. The overwrite case isn't used that much because as you've
found its really hard to use without a valid tail pointer. So I'm not too
bothered about making the overwrite case a _little_ more expensive if that
makes it far more usable.

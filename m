Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab3EaP4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:56:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43964 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab3EaP4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:56:35 -0400
Date: Fri, 31 May 2013 17:56:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Hunter <ahh@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, mingo@redhat.com
Subject: Re: [PATCH] perf: reduce stack usage of schedule_events
Message-ID: <20130531155629.GH27176@twins.programming.kicks-ass.net>
References: <1369332423-4400-1-git-send-email-ahh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369332423-4400-1-git-send-email-ahh@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 11:07:03AM -0700, Andrew Hunter wrote:
> schedule_events caches event constraints on the stack during
> scheduling.  Given the number of possible events, this is 512 bytes of
> stack; since it can be invoked under schedule() under god-knows-what,
> this is causing stack blowouts.
> 
> Trade some space usage for stack safety: add a place to cache the
> constraint pointer to struct perf_event.  For 8 bytes per event (1% of
> its size) we can save the giant stack frame.
> 
> This shouldn't change any aspect of scheduling whatsoever and while in
> theory the locality's a tiny bit worse, I doubt we'll see any
> performance impact either.
> 
> Tested: `perf stat whatever` does not blow up and produces
> results that aren't hugely obviously wrong.  I'm not sure how to run
> particularly good tests of perf code, but this should not produce any
> functional change whatsoever.
> 
> Signed-off-by: Andrew Hunter <ahh@google.com>
> Reviewed-by: Stephane Eranian <eranian@google.com>

OK nothing really strange popped out during a quick read.

Thanks!
